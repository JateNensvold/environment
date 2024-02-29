{ lib, inputs, dotfiles, hosts, hardwares, systems, isNixOS, isMacOS, isIso, isHardware, nixpkgs, home-manager, nix-darwin, ... }:
let
  mkHost = { host, hardware, stateVersion, system, extraOverlays, extraModules }: isNixOS: isMacOS: isIso: isHardware:
    let

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnsupportedSystem = true;
        };
        overlays = [
        ] ++ extraOverlays;
      };
      extraArgs = { inherit pkgs inputs isIso isHardware dotfiles hardware system stateVersion; hostname = host + "-" + hardware; };
    in

    home-manager.lib.homeManagerConfiguration
      {
        inherit pkgs;
        extraSpecialArgs = extraArgs;
        modules = [
          ../home/default.nix
          ./${ host }/home.nix
        ];
      };

  hardwarePermutedHosts = lib.concatMap (hardware: map (host: host // hardware) hosts) hardwares;
  systemsPermutedHosts = lib.concatMap (system: map (host: host // system) hardwarePermutedHosts) systems;
  permutedHosts = systemsPermutedHosts;

in

  /*
    We have a list of sets.
    Map each element of the list applying the mkHost function to its elements and returning a set in the listToAttrs format
    builtins.listToAttrs on the result
  */
builtins.listToAttrs (map
  (mInput@{ host, hardware, system, ... }: {
    name = host + "-" + hardware + "-" + system;
    value = mkHost mInput isNixOS isMacOS isIso isHardware;
  })
  permutedHosts)
