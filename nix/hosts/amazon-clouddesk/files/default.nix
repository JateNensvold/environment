{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # Dynamic files
  home.file.".vscode-server/data/Machine/java_settings.xml".source =
    link "${dotfilePath}/vscode/work/java_settings.xml";
  home.file.".vscode-server/data/Machine/settings.json".source =
    link "${dotfilePath}vscode/settings.json";
}
