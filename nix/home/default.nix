# Main user-level configuration
{ config, lib, pkgs, user, host, hardware, system, dotfiles, stateVersion, ...
}:

let
  homeDirectoryPrefix =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
  reloadHomeManagerSuffix =
    "switch --flake ~/environment#$USER-$NIX_HOST-$HARDWARE-$ARCH";
  reloadHomeManagerPrefix = if pkgs.stdenv.hostPlatform.isDarwin then
    "darwin-rebuild"
  else
    "home-manager";

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
    stateVersion = stateVersion;

    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      NIX_HOST = host;
      HARDWARE = hardware;
      ARCH = system;
      TMUX_SESSIONIZER_PATHS =
        lib.concatStringsSep ":" [ "~" "~/projects" "~/workspace" ];
      EDITOR = "vim";
      RELOAD_PREFIX = "${reloadHomeManagerPrefix}";
      RELOAD_SUFFIX = "${reloadHomeManagerSuffix}";
    };
    shellAliases = {
      reload-home-manager-config =
        "${reloadHomeManagerPrefix} ${reloadHomeManagerSuffix}";
    };
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 29d";
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
  ];
}
