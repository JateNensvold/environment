{ lib, config, user, host, hardware, pkgs, stablePkgs, ... }:
let
  modulePath = "./modules";
  hostPath = "./hosts";
in {

  # have to enable zsh in darwin config due to some weird darwin bug
  programs.zsh.enable = true;

  imports = [ ./${hostPath}/${host}/darwin ];

  # nix-darwin configuration
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
  };

  # home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    users."${user}" = {
      imports = [
        ./${modulePath}/home/default.nix
        ./${hostPath}/${host}/home.nix
        ./${modulePath}/shared/user/${user}/default.nix
        ./${modulePath}/shared/hardware/${hardware}/default.nix
      ];
    };
    backupFileExtension = "hm-backup";
  };

  services.nix-daemon.enable = true;

  nix = {
    settings.experimental-features = "nix-command flakes";
    settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  };

  environment.systemPackages = [ ]
    ++ (import ./${modulePath}/home/packages.nix { inherit pkgs stablePkgs; });

  fonts.fontDir.enable = true;

  system.defaults = {
    dock = {
      orientation = "left";
      autohide = false;
      show-recents = false;
      # disable bottom right corner as MacOS hot corner
      wvous-br-corner = 1;
      # config is only reloaded when dock is restarted
      # - killall Dock
    };
    NSGlobalDomain = { "com.apple.swipescrolldirection" = false; };
    finder = { _FXShowPosixPathInTitle = true; };
  };

  # https://github.com/zmre/mac-nix-simple-example
  homebrew = {
    enable = true;
    casks = [
      "docker" # docker packaging is broken on non nixos systems
    ];

    # Install apps from mac store
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # nix shell nixpkgs#mas
    # mas search <app name>
    masApps = { "amphetamine" = 937984704; };
  };

  system.activationScripts.postUserActivation.text = ''
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/${user}/environment/settings/wezterm/backgrounds/smoke-1178319.jpg"'
  '';

  # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
    applications="$HOME/Applications"
    nix_apps="$applications/Nix Apps"

    # Needs to be writable by the user so that home-manager can symlink into it
    if ! test -d "$applications"; then
        mkdir -p "$applications"
        chown ${user}: "$applications"
        chmod u+w "$applications"
    fi

    # Delete the directory to remove old links
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
            # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
            # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
            # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
            /usr/bin/osascript -e "
                set fileToAlias to POSIX file \"$src\"
                set applicationsFolder to POSIX file \"$nix_apps\"
                tell application \"Finder\"
                    make alias file to fileToAlias at applicationsFolder
                    # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                    set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                end tell
            " 1>/dev/null
        done
  '';

}
