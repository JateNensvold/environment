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
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/claude/CLAUDE.md";
  home.file.".claude/commands".source = "${dotfiles}/claude/commands";

  home.file.".config/.cspell".source = "${dotfiles}/cspell";

  home.file.".config/cheat/cheatsheets/community".source = builtins.fetchGit {
    url = "https://github.com/cheat/cheatsheets";
    rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
  };
}
