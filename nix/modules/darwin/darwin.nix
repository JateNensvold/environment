{ user, system, ... }: {
  users.users."${user}".home = "/Users/${user}";
  environment.systemPackages = [ ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "${system}";

  # have to enable zsh in darwin config due to some weird darwin bug
  programs.zsh.enable = true;

  system.defaults = { dock = { orientation = "left"; }; };

  # https://github.com/zmre/mac-nix-simple-example
  homebrew = { enable = true; };
}
