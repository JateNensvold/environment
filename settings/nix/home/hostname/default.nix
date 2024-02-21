{ config, lib, ... }:

let
  hostnamePath = "./${config.user.hostname}.nix";
in
{
  home.sessionVariables = {
    HOST_NAME = "${config.user.hostname}";
    EDITOR_1 = "VIM";
  };
  # imports = [
  # ] ++ lib.optional (builtins.pathExists hostnamePath) import hostnamePath
  # ;
}
