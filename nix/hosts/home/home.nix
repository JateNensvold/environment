{ config, lib, pkgs, inputs, user, hostname, location, secrets, dotfiles, ... }:
let
in
{
  programs.zsh.initExtra = ''
    # Source brew path, should be present if system was setup by bash https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  '';

  home.packages = with pkgs; [
  ] ++
  (with pkgs.custom; [
  ]);
}