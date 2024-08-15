{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # Link host specific files into home directory
}
