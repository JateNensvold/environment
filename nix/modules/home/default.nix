# Main user-level configuration
{ config, pkgs, lib, user, host, hardware, system, dotfiles, stateVersion, isOther
, ... }:

let
  homeDirectoryPrefix =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
  dotfilePath = "${homeDirectoryPrefix}/${user}/environment/dotfiles";
  _reloadHomeManagerSuffix =
    "switch --flake ~/environment#$USER-$NIX_HOST-$HARDWARE-$ARCH";

  reloadHomeManagerSuffix = if isOther then
    _reloadHomeManagerSuffix + " -b hm-backup"
  else
    _reloadHomeManagerSuffix;

  reloadHomeManagerPrefix =
    if pkgs.stdenv.isDarwin then "sudo darwin-rebuild" else "home-manager";
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
      EDITOR = "vim";
      LESS = "-eirMX";
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
    dates = "weekly";
    options = "--delete-older-than 29d";
  };

  home.activation.merge-claude-settings =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      claude_dir="$HOME/.claude"
      settings="$claude_dir/settings.json"
      dotfile_settings="${dotfilePath}/claude/settings.json"

      if [ -f "$dotfile_settings" ]; then
        mkdir -p "$claude_dir"
        if [ -f "$settings" ]; then
          # Deep merge dotfile settings into existing settings (dotfile values win on conflict)
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$settings" "$dotfile_settings" > "$settings.tmp" \
            && mv "$settings.tmp" "$settings"
        else
          cp "$dotfile_settings" "$settings"
        fi
      fi
    '';

  imports = [
    # program and dotfile installation/setup
    (import ./files/default.nix { inherit dotfiles config; })
    # (import ./programs.nix { inherit config lib pkgs dotfiles; })
    (import ./programs.nix)
  ];
}
