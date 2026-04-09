{ config, pkgs, lib, ... }:
let
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
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

    merge-claude-settings =
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
  };
}
