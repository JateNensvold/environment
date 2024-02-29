{}:
{
  home = {
    zsh = {
      shellAliases = {
        bb = "brazil-build";
        bre = "brazil-runtime-exec";
        brc = "brazil-recursive-cmd";
        bws = "brazil ws";
        bbb = "brc --allPackages brazil-build";
      };
    };
    sessionVariables = {
      BRAZIL_WORKSPACE_DEFAULT_LAYOUT = "short";
      AUTO_TITLE_SCREENS = "NO";
      AWS_EC2_METADATA_DISABLED = true;
      PATH = "$HOME/.toolbox/bin:$PATH";
    };
  };
}
