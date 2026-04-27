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
  home.file.".config/tmux".source = "${dotfiles}/tmux";
  # Keep local scripts live from the repo so sandbox wrapper edits are
  # immediately visible without waiting for a reload.
  home.file.".local/bin".source = link "${dotfilePath}/scripts/bash/default";
  home.file.".zfuncs".source = "${dotfiles}/scripts/zsh/default";
  home.file.".config/oh-my-posh".source = "${dotfiles}/oh-my-posh";
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/agents/claude/CLAUDE.md";
  # Keep shared agent command and workflow trees live from the repo so edits
  # are visible after the next reload without another Home Manager rebuild.
  home.file.".claude/commands".source = link "${dotfilePath}/agents/claude/commands";
  home.file.".agents/workflows".source = link "${dotfilePath}/agents/workflows";
  home.file.".codex/AGENTS.md".source = link "${dotfilePath}/agents/codex/AGENTS.md";
  home.file.".codex/hooks/agent_memory_common.py".source =
    "${dotfiles}/agents/codex/hooks/agent_memory_common.py";
  home.file.".codex/hooks/session_start_context.py".source =
    "${dotfiles}/agents/codex/hooks/session_start_context.py";
  home.file.".codex/skills".source = link "${dotfilePath}/agents/codex/skills";

  home.file.".config/.cspell".source = "${dotfiles}/cspell";

  home.file.".config/cheat/cheatsheets/community".source = builtins.fetchGit {
    url = "https://github.com/cheat/cheatsheets";
    rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
  };
}
