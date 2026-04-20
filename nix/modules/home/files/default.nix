{ dotfiles, ... }:
{

  # Static files
  home.file.".config/cheat/conf.yml".source = "${dotfiles}/cheat/conf.yml";
  home.file.".inputrc".source = "${dotfiles}/dotfile_settings/.inputrc";

  # Install from the flake source (in-store) to avoid "outside $HOME" errors during build.
  home.file.".config/nvim".source = "${dotfiles}/nvim/default";
  home.file.".config/tmux".source = "${dotfiles}/tmux";
  home.file.".local/bin".source = "${dotfiles}/scripts/bash/default";
  home.file.".zfuncs".source = "${dotfiles}/scripts/zsh/default";
  home.file.".config/oh-my-posh".source = "${dotfiles}/oh-my-posh";
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/agents/claude/CLAUDE.md";
  home.file.".claude/commands".source = "${dotfiles}/agents/claude/commands";
  home.file.".agents/workflows".source = "${dotfiles}/agents/workflows";
  home.file.".codex/AGENTS.md".source = "${dotfiles}/agents/codex/AGENTS.md";
  home.file.".codex/hooks/agent_memory_common.py".source =
    "${dotfiles}/agents/codex/hooks/agent_memory_common.py";
  home.file.".codex/hooks/session_start_context.py".source =
    "${dotfiles}/agents/codex/hooks/session_start_context.py";
  home.file.".codex/skills/ccommit".source = "${dotfiles}/agents/codex/skills/ccommit";
  home.file.".codex/skills/cprep".source = "${dotfiles}/agents/codex/skills/cprep";
  home.file.".codex/skills/cexplore".source = "${dotfiles}/agents/codex/skills/cexplore";
  home.file.".codex/skills/creview".source = "${dotfiles}/agents/codex/skills/creview";
  home.file.".codex/skills/creviewcommit".source =
    "${dotfiles}/agents/codex/skills/creviewcommit";
  home.file.".codex/skills/csubmit".source = "${dotfiles}/agents/codex/skills/csubmit";
  home.file.".codex/skills/ctest".source = "${dotfiles}/agents/codex/skills/ctest";

  home.file.".config/.cspell".source = "${dotfiles}/cspell";

  home.file.".config/cheat/cheatsheets/community".source = builtins.fetchGit {
    url = "https://github.com/cheat/cheatsheets";
    rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
  };
}
