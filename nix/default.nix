{ lib, flakeInputs, dotfiles, users, hosts, hardwares, hostSystems, isNixOS
, isMacOS, isIso, isHardware, nixpkgs, nixpkgsStable, home-manager, nix-darwin
, ... }:
let
  mkHost =
    { user, host, extraOverlays, extraModules, hardware, stateVersion, system }:
    isNixOS: isMacOS: isIso: isHardware:

    let

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnsupportedSystem = true;
        };
        overlays = [
          # import program overlays
          (import ./packages)
          (import ./overlays/pinned.nix)
        ] ++ extraOverlays;
      };

      stablePkgs = import nixpkgsStable {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnsupportedSystem = true;
        };
        overlays = [ ];
      };

      my-lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs;
          inputs = flakeInputs;
          lib = self;
        };
      });
      extraArgs = {
        inherit pkgs stablePkgs flakeInputs isIso isHardware dotfiles
          home-manager user hardware host system stateVersion my-lib;
        hostname = host + "-" + hardware;
        isOther = !(isMacOS || isNixOS);
      };

    in if isMacOS then
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = extraArgs;
        modules = [
          home-manager.darwinModules.home-manager
          { home-manager.extraSpecialArgs = extraArgs; }
          flakeInputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = flakeInputs.homebrew-core;
                "homebrew/homebrew-cask" = flakeInputs.homebrew-cask;
                "homebrew/homebrew-bundle" = flakeInputs.homebrew-bundle;
              };
            };
          }
          ./darwin.nix
        ];
      }
    else
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = extraArgs;
        modules = [ ./linux.nix ];
      };

  userPermutedHosts =
    lib.concatMap (user: map (host: host // user) hosts) users;
  hardwarePermutedHosts = lib.concatMap
    (hardware: map (permutation: permutation // hardware) userPermutedHosts)
    hardwares;
  systemsPermutedHosts = lib.concatMap
    (system: map (permutation: permutation // system) hardwarePermutedHosts)
    hostSystems;
  permutedHosts = systemsPermutedHosts;

  /* Dynamically generate a list of mkHost options so each combination of user/host/hardware/system do not have to be manually created
     We have a list of sets. Map each element of the list applying the mkHost function to its elements and returning a set in the listToAttrs format
     builtins.listToAttrs on the result
  */
in builtins.listToAttrs (map (mInput@{ user, host, hardware, system, ... }: {
  name = user + "-" + host + "-" + hardware + "-" + system;
  value = mkHost mInput isNixOS isMacOS isIso isHardware;
}) permutedHosts)
