{ config, dotfiles, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # Recursive static folder
  home.file.".zfuncs/a" = { source = "${dotfiles}/scripts/zsh/work/a"; };

  # Dynamic files
  home.file."Library/Application Support/Code/User/settings.json".source =
    link "${dotfilePath}/vscode/settings.json";
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    link "${dotfilePath}/vscode/keybindings.json";
}
