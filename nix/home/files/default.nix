{ config, lib, pkgs, dotfiles, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  # Static files
  home.file.".zfuncs".source = "${dotfiles}/dotfile_settings/zsh_scripts";
  home.file.".p10k.zsh".source = "${dotfiles}/dotfile_settings/.p10k.zsh";
  home.file.".config/cheat/conf.yml".source = "${dotfiles}/cheat/conf.yml";
  home.file.".inputrc".source = "${dotfiles}/dotfile_settings/.inputrc";

  # Dynamic File (needs to link to a full path to remain pure https://github.com/nix-community/home-manager/issues/2085)

  # Dynamic folder
  home.file.".config/cheat/cheatsheets/personal".source = link "${dotfiles}/cheat/cheats";
}
