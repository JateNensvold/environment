{ dotfiles, config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in
{

  # Static files
  home.file.".config/cheat/conf.yml".source = "${dotfiles}/cheat/conf.yml";
  home.file.".inputrc".source = "${dotfiles}/dotfile_settings/.inputrc";

  # Install most shared trees from the flake source (in-store) to avoid
  # "outside $HOME" errors during build.
  home.file.".config/nvim".source = "${dotfiles}/nvim/default";
  # Keep tmux + local scripts live from the repo so edits are immediately
  # visible without waiting for a reload.
  home.file.".config/tmux".source = link "${dotfilePath}/tmux";
  home.file.".local/bin".source = link "${dotfilePath}/scripts/bash/default";
  home.file.".zfuncs".source = "${dotfiles}/scripts/zsh/default";
  home.file.".config/oh-my-posh".source = "${dotfiles}/oh-my-posh";
  home.file.".config/direnv/direnv.toml".source = link "${dotfilePath}/direnv/direnv.toml";
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/agents/claude/CLAUDE.md";
  # Install shared agent trees from the flake source so sandboxed sessions can
  # resolve them without depending on extra bind mounts back into this repo.
  home.file.".claude/commands".source = "${dotfiles}/agents/claude/commands";
  home.file.".claude/hooks/session_start_context.py".source =
    "${dotfiles}/agents/claude/hooks/session_start_context.py";
  home.file.".claude/hooks/agent_memory_common.py".source =
    "${dotfiles}/agents/codex/hooks/agent_memory_common.py";
  home.file.".agents/workflows".source = "${dotfiles}/agents/workflows";
  home.file.".codex/AGENTS.md".source = "${dotfiles}/agents/codex/AGENTS.md";
  home.file.".codex/hooks/agent_memory_common.py".source =
    "${dotfiles}/agents/codex/hooks/agent_memory_common.py";
  home.file.".codex/hooks/session_start_context.py".source =
    "${dotfiles}/agents/codex/hooks/session_start_context.py";
  home.file.".codex/skills".source = "${dotfiles}/agents/codex/skills";

  home.file.".config/.cspell".source = link "${dotfilePath}/cspell";

  home.file.".config/cheat/cheatsheets/community".source = builtins.fetchGit {
    url = "https://github.com/cheat/cheatsheets";
    rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
  };
}
