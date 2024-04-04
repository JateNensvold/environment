{ pkgs, ... }: {
  imports = [ ./files/default.nix ../common/amazon.nix ];

  home.packages = [ pkgs.jdk ];
  home.sessionVariables = { };
}
