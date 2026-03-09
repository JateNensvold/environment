{ config, pkgs, lib, ... }: {
  home.activation = {

    rsync-home-manager-applications =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        apps_source="${config.home.homeDirectory}/Applications/Home Manager Apps/"
        echo "$apps_source"
        ls -la "$apps_source"

        moniker="Nix Trampolines"
        app_target_base="$HOME/Applications"
        app_target="$app_target_base/$moniker"
        mkdir -p "$app_target"
        ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"

      '';
  };
}
