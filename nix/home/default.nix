# Main user-level configuration
{ config, lib, pkgs, user, host, hardware, system, dotfiles, ... }:

let
  homeDirectoryPrefix =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    username = user;
    homeDirectory = "${homeDirectoryPrefix}/${user}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      NIX_HOST = host;
      HARDWARE = hardware;
      ARCH = system;
      TMUX_SESSIONIZER_PATHS =
        lib.concatStringsSep ":" [ "~" "~/projects" "~/workspace" ];
    };
    shellAliases = {
      reload-home-manager-config =
        "home-manager switch --flake ~/environment/nix#$USER-$NIX_HOST-$HARDWARE-$ARCH";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      # sometimes it is useful to pin a version of some tool or program.
      # this can be done in " overlays/pinned.nix "
      (import ../overlays/pinned.nix)
    ];
  };

  # Flakes are not standard yet, but widely used, enable them.
  xdg.configFile."nix/nix.conf ".text = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    # Programs to install
    ./packages.nix
    (import ./files/default.nix { inherit config lib pkgs dotfiles; })
    (import ./programs.nix { inherit config lib pkgs dotfiles; })

    # Host Specific setup
    ../hosts/${host}/home.nix
    ../user/${user}/default.nix
    ../hardware/${hardware}/default.nix
  ];
  #  ++ (modules.importAllModules ./modules);
}
