{ lib, inputs, config, pkgs, dotfiles, ... }:
let

in {

  # Recursive static folder
  home.file.".zfuncs/a" = { source = "${dotfiles}/scripts/zsh/work/a"; };

  # Dynamic files
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.meta.mkMutableSymlink "/vscode/settings.json";
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    config.lib.meta.mkMutableSymlink "/vscode/keybindings.json";
}
