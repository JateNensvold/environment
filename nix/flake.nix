{

  description = "My Nix config";
  # Inspired by https://github.com/Baitinq/nixos-config/blob/df435deda17e75eb994305a49e6d94685a40d2c2/flake.nix

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:NixOS/nixos-hardware";

    hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

  };

  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, ... }:
    let

      dotfiles = ./dotfiles;

      name = builtins.getEnv "USER";
      home = builtins.getEnv "HOME";

      users = [
        # Desktop
        { user = "tosh"; }
        # Laptop
        { user = "nate"; }
        # Work user
        { user = "jensvold"; }
      ];

      hosts = [
        { host = "home"; extraOverlays = [ ]; extraModules = [ ]; }
        # Work devices
        { host = "amazon-clouddesk"; extraOverlays = [ ]; extraModules = [ ]; }
        { host = "amazon-laptop"; extraOverlays = [ ]; extraModules = [ ]; }
      ];

      hardwares = [
        { hardware = "default"; stateVersion = "23.11"; }
        { hardware = "macbook"; stateVersion = "23.11"; }
      ];

      systems = [
        { system = "x86_64-linux"; }
        { system = "x86_64-darwin"; }
        { system = "aarch64-linux"; }
        { system = "aarch64-darwin"; }
      ];


      commonInherits = {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager nix-darwin;
        inherit users hosts dotfiles hardwares systems;
      };

    in
    {
      # darwinConfigurations = import ./hosts (commonInherits // {
      #   isNixOS = false;
      #   isMacOS = true;
      #   isIso = false;
      #   isHardware = true;
      # });

      # imports = [
      #   ./modules/nix.nix
      # ];

      homeConfigurations = import ./hosts (commonInherits // {
        isNixOS = false;
        isMacOS = false;
        isIso = false;
        isHardware = false;
      });



      # home-manager.lib.homeManagerConfiguration
      # {
      #   inherit pkgs;
      #   extraSpecialArgs = extraArgs;
      # modules = [
      #   ./home.nix
      #   ./${ host }/home.nix
      # ];
      # };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;


      tests = inputs.nixtest.run ./.;

    };
}
