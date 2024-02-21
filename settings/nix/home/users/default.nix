{ config, lib, pkgs, ... }:
let
  userPackagesPath = ./users + "/${config.user.name}/$packages.nix";
in
{
  # home.packages = with pkgs; (
  #   lib.optional (builtins.pathExists userPackagesPath) import userPackagesPath { inherit pkgs; }
  # );
}
