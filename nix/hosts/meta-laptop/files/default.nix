{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  settingsPath = "${config.home.homeDirectory}/environment/settings";
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # Recursive static folder

  # Dynamic files
  home.file."Library/Application Support/Code/User/settings.json".source =
    link "${dotfilePath}/vscode/settings.json";
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    link "${dotfilePath}/vscode/keybindings.json";

  home.file.".config/wezterm/wezterm.lua".source =
    link "${settingsPath}/wezterm/wezterm.lua";

  home.file.".aerospace.toml".source =
    link "${dotfilePath}/aerospace/work/meta/aerospace.toml";
}
