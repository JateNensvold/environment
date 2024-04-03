{ config, lib, inputs, pkgs, dotfiles, ... }: {
  imports = [ ./files/default.nix ../common/amazon.nix ];

  home.packages = [ pkgs.jdk ];
  home.sessionVariables = { };
}
