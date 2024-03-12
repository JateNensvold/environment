{ lib, inputs, config, pkgs, dotfiles, ... }:
let

in
{
  # Dynamic files
  home.file.".vscode-server/data/Machine/java_settings.xml".source = config.lib.meta.mkMutableSymlink "/vscode/work/java_settings.xml";
}
