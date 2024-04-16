{ ... }:

let
  # put a shell script into the nix store
  # gitIdentity =
  #   pkgs.writeShellScriptBin "git-identity" (builtins.readFile dotfiles/scripts/default/bash./git-identity);
in {
  # we will use the excellent fzf in our `git-identity` script, so let's make sure it's available
  # let's add the gitIdentity script to the path as well

  programs.git = {
    enable = true;

    extraConfig = {
      user.personal.name = "Nate Jensvold";
      user.personal.email = "jensvoldnate@gmail.com";

      # extremely important, otherwise git will attempt to guess a default user identity. see `man git-config` for more details
      user.useConfigOnly = true;

      core = { pager = "delta"; };
      diff = {
        tool = "default-difftool";
        colorMoved = "default";
      };
      interactive = { diffFilter = "delta --color-only"; };
      delta = {
        navigate = "true";
        light = "false";
      };
      merge = { conflictstyle = "diff3"; };
      init = { defaultBranch = "master"; };
      pull = { rebase = "true"; };
      url."git@github.com:" = { insteadOf = "https://github.com/"; };
    };

    # This is optional, as `git identity` will call the `git-identity` script by itself, however
    # setting it up explicitly as an alias gives you autocomplete
    aliases = {
      identity = "! git-identity";
      id = "! git-identity";
    };

  };

  # programs.git = {
  #   extraConfig = {
  #
  #     # the `work` identity
  #     user.work.name = "Spider-Man";
  #     user.work.email = "friendlyspidey@neighborhood.com";
  #
  #   };
  # };

}
