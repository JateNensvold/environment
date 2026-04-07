{ user, host, hardware, pkgs, stablePkgs, ... }:
let
  modulePath = "./modules";
  hostPath = "./hosts";
in {

  # have to enable zsh in darwin config due to some weird darwin bug
  programs.zsh.enable = true;

  imports = [ ./${hostPath}/${host}/darwin ];

  # Set the primary user for options that require it (dock, homebrew, launchd, etc.)
  system.primaryUser = user;

  # nix-darwin configuration
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    shell = pkgs.zsh;
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

  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  };

  ids.gids.nixbld = 350;

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

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Allow passwordless darwin-rebuild for the primary user
  security.sudo.extraConfig = ''
    ${user} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild
  '';

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
    masApps = { };
  };

  # Set desktop background and enable extended keypress in vscode
  system.activationScripts.postActivation.text = ''
    sudo -u ${user} osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/${user}/environment/settings/wezterm/backgrounds/water-background.png"'

    sudo -u ${user} defaults write com.facebook.vscode ApplePressAndHoldEnabled -bool false
    sudo -u ${user} defaults write com.facebook.fbvscode ApplePressAndHoldEnabled -bool false
    sudo -u ${user} defaults write com.facebook.fbvscode-insiders ApplePressAndHoldEnabled -bool false
    sudo -u ${user} defaults write com.facebook.fbvscode-dev ApplePressAndHoldEnabled -bool false
    sudo -u ${user} defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    sudo -u ${user} defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
  '';
}
