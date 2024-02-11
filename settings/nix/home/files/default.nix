{ config, lib, pkgs, settings_dir, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  # Static files
  home.file.".zfuncs".source = "${settings_dir}/dotfile_settings/zsh_scripts";
  home.file.".p10k.zsh".source = "${settings_dir}/dotfile_settings/.p10k.zsh";
  home.file.".config/cheat/conf.yml".source = "${settings_dir}/cheat/conf.yml";
  home.file.".inputrc".source = "${settings_dir}/dotfile_settings/.inputrc";

  # Dynamic File (needs to link to a full path to remain pure https://github.com/nix-community/home-manager/issues/2085)
  # home.file.".config/git/config".source = link "${settings_dir}/dotfile_settings/.gitconfig";

  # Dynamic folder
  home.file.".config/cheat/cheatsheets/personal".source = link "${settings_dir}/cheat/cheats";
}
