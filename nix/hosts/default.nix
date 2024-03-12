{ lib, inputs, dotfiles, users, hosts, hardwares, systems, isNixOS, isMacOS, isIso, isHardware, nixpkgs, home-manager, nix-darwin, ... }:
let
  mkHost = { user, host, hardware, stateVersion, system, extraOverlays, extraModules }: isNixOS: isMacOS: isIso: isHardware:
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
      extraArgs = { inherit pkgs inputs isIso isHardware dotfiles home-manager user hardware host system stateVersion; hostname = host + "-" + hardware; };
    in

    home-manager.lib.homeManagerConfiguration
      {
        inherit pkgs;
        extraSpecialArgs = extraArgs;
        modules = [
          ../modules/nix.nix
          ../home/default.nix
          ./${ host }/home.nix
          ../user/${ user }/default.nix
          ../hardware/${ hardware }/default.nix
        ];
      };

  userPermutedHosts = lib.concatMap (user: map (host: host // user) hosts) users;
  hardwarePermutedHosts = lib.concatMap (hardware: map (host: host // hardware) userPermutedHosts) hardwares;
  systemsPermutedHosts = lib.concatMap (system: map (host: host // system) hardwarePermutedHosts) systems;
  permutedHosts = systemsPermutedHosts;

in

  /*
    We have a list of sets.
    Map each element of the list applying the mkHost function to its elements and returning a set in the listToAttrs format
    builtins.listToAttrs on the result
  */
builtins.listToAttrs (map
  (mInput@{ user, host, hardware, system, ... }: {
    name = user + "-" + host + "-" + hardware + "-" + system;
    value = mkHost mInput isNixOS isMacOS isIso isHardware;
  })
  permutedHosts)
