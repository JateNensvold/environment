{ user, host, hardware, pkgs, stablePkgs, stateVersion, ... }:
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
        ./${modulePath}/darwin/home-manager
      ];
    };
    backupFileExtension = "hm-backup";
  };

  services.nix-daemon.enable = true;

  nix = {
    settings.experimental-features = "nix-command flakes";
    settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  };

  launchd = {
    user = {
      agents = {
        aerospace = {
          command = "Open ${pkgs.custom.aerospace}/Applications/Aerospace.app";
          serviceConfig = {
            KeepAlive = { Crashed = true; };
            RunAtLoad = true;
            StandardOutPath = "/tmp/aerospace.out.log";
            StandardErrorPath = "/tmp/aerospace.err.log";
          };
        };
      };
    };
  };

  environment.systemPackages = [ ]
    ++ (import ./${modulePath}/home/packages.nix { inherit pkgs stablePkgs; });

  system = {
    # Controls nixbld GID when upgrading nix-darwin. 4 means to keep previous GID
    stateVersion = 4;
    defaults = {
      dock = {
        orientation = "left";
        autohide = false;
        show-recents = false;
        # disable bottom right corner as MacOS hot corner
        wvous-br-corner = 1;
      };
      NSGlobalDomain = { "com.apple.swipescrolldirection" = false; };
      finder = { _FXShowPosixPathInTitle = true; };
    };
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
}
