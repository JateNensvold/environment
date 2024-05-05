{ dotfiles, config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {

  # Static files
  home.file.".zfuncs" = {
    source = "${dotfiles}/scripts/zsh/default";
    recursive = true;
  };
  home.file.".p10k.zsh".source = "${dotfiles}/dotfile_settings/.p10k.zsh";
  home.file.".config/cheat/conf.yml".source = "${dotfiles}/cheat/conf.yml";
  home.file.".inputrc".source = "${dotfiles}/dotfile_settings/.inputrc";

  # Dynamic File (needs to link to a full path to remain pure https://github.com/nix-community/home-manager/issues/2085)
  # see ../../modules/nix.nix for util function
  home.file.".config/nvim".source = link "${dotfilePath}/nvim/default";
  home.file.".config/tmux".source = link "${dotfilePath}/tmux";
  home.file.".local/bin".source = link "${dotfilePath}/scripts/bash/default";

  home.file.".config/cheat/cheatsheets/community".source = builtins.fetchGit {
    url = "https://github.com/cheat/cheatsheets";
    rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
  };
}
