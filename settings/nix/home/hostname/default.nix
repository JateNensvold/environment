{ config, lib, ... }:

let
  # hostnamePath = "./${config.user.hostname}.nix";
  hostnamePath = ./amazon.nix;
in
{
  home.sessionVariables = {
    HOST_NAME = "${config.user.hostname}";
  };


  # imports = [
  # ] ++ lib.optional (builtins.pathExists hostnamePath) import hostnamePath;

}
