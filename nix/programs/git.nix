{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
  excludesfilePath = "~/.config/git/personal/.gitignore";
in {
  home.file.".config/git/personal/.gitignore".source =
    link "${dotfilePath}/git/personal/.gitignore";

  programs.git = {
    enable = true;
    extraConfig = {
      user.personal = {
        name = "Nate Jensvold";
        email = "jensvoldnate@gmail.com";
        excludesfile = excludesfilePath;
      };

      # extremely important, otherwise git will attempt to guess a default user identity. see `man git-config` for more details
      user.useConfigOnly = true;

      core = { pager = "delta"; };
      diff = {
        tool = "default-difftool";
        colorMoved = "default";
      };

      merge = { tool = "nvim"; };
      mergetool = {
        prompt = false;
        "nvim" = { cmd = "nvim -f -c GitConflictListQf"; };
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
      who = ''
        !f() {
            user=$(git config user.name)
            email=$(git config user.email)

            echo "User=[$user]"
            echo "Email=[$email]"
          }
          f
      '';
    };
  };
}
