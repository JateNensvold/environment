{ config, lib, pkgs, inputs, user, hostname, location, secrets, dotfiles, ... }:
{
  home.packages = with pkgs; [
  ] ++
  (with pkgs.custom; [
  ]);
}