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

  imports = [
    # program and dotfile installation/setup
    (import ./files/default.nix { inherit dotfiles config; })
    (import ./programs.nix { inherit config lib pkgs dotfiles; })
  ];
}
