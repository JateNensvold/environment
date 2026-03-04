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
  # rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
  # apps_source="$genProfilePath/home-path/Applications"
  # moniker="Home Manager Trampolines"
  # app_target_base="${config.home.homeDirectory}/Applications"
  # app_target="$app_target_base/$moniker"
  # mkdir -p "$app_target"
  # ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
  #     '';
  # };

  #   aliasHomeManagerApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #           app_folder="${config.home.homeDirectory}/Applications/Home Manager Trampolines"
  #           rm -rf "$app_folder"
  #           mkdir -p "$app_folder"
  #
  #     # Check if the filepath does not exist
  #     if [ ! -e "$genProfilePath/home-path/Applications" ]; then
  #       echo "Unable to find $genProfilePath/home-path/Applications"
  #      exit
  #     fi
  #
  #           find "$genProfilePath/home-path/Applications" -type l -print | while read -r app; do
  #               app_target="$app_folder/$(basename "$app")"
  #               real_app="$(readlink "$app")"
  #               echo "mkalias \"$real_app\" \"$app_target\"" >&2
  #               $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
  #           done
  #   '';
  # };
}
