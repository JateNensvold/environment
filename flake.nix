{
  description = "My Nix config";
  # Inspired by https://github.com/Baitinq/nixos-config/blob/df435deda17e75eb994305a49e6d94685a40d2c2/flake.nix

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs/23.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = flakeInputs@{ self, nixpkgs, nixpkgsStable, home-manager, nix-darwin
    , flake-utils, ... }:
    let
      dotfiles = ./dotfiles;

      users = [
        # Desktop
        {
          user = "tosh";
        }
        # Laptop
        {
          user = "nate";
        }
        # Work user
        { user = "jensvold"; }
      ];

      hosts = [
        {
          host = "home";
          extraOverlays = [ ];
          extraModules = [ ];
        }
        # Work devices
        {
          host = "amazon-clouddesk";
          extraOverlays = [ ];
          extraModules = [ ];
        }
        {
          host = "amazon-laptop";
          extraOverlays = [ ];
          extraModules = [ ];
        }
      ];

      hardwares = [
        {
          hardware = "default";
          stateVersion = "22.05";
        }
        {
          hardware = "macbook";
          stateVersion = "22.05";
        }
      ];

      hostSystems = [
        { system = "x86_64-linux"; }
        { system = "x86_64-darwin"; }
        { system = "aarch64-darwin"; }
      ];

      commonInherits = {
        inherit (nixpkgs) lib;
        inherit flakeInputs nixpkgs nixpkgsStable home-manager nix-darwin;
        inherit users hosts dotfiles hardwares hostSystems;
      };

    in {

      homeConfigurations = import ./nix/default.nix (commonInherits // {
        isNixOS = false;
        isMacOS = false;
        isIso = false;
        isHardware = false;
      });

      darwinConfigurations = import ./nix/default.nix (commonInherits // {
        isNixOS = false;
        isMacOS = true;
        isIso = false;
        isHardware = true;
      });

      tests = flakeInputs.nixtest.run ./.;

    } // flake-utils.lib.eachDefaultSystem (system:
      let shellPkgs = import nixpkgs { inherit system; };
      in {
        devShell = shellPkgs.mkShell {
          packages = with shellPkgs;
            [
              # dev packages
            ] ++
            # darwin specific tools
            lib.optional shellPkgs.stdenv.isDarwin dockutil;
        };
      });
}
