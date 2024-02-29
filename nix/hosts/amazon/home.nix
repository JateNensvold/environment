{ config, lib, pkgs, inputs, user, hostname, dotfiles, ... }:
{

  home = {
    shellAliases = {
      bb = "brazil-build";
      bre = "brazil-runtime-exec";
      brc = "brazil-recursive-cmd";
      bws = "brazil ws";
      bbb = "brc --allPackages brazil-build";
    };
    sessionVariables = {
      # export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
      # export AUTO_TITLE_SCREENS="NO"
      # export AWS_EC2_METADATA_DISABLED=true
      # export PATH=$HOME/.toolbox/bin:$PATH
    };
  };

  home.packages = with pkgs; [
  ] ++
  (with pkgs.custom; [
  ]);
}
