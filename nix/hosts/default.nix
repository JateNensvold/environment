{ lib, flakeInputs, dotfiles, users, hosts, hardwares, systems, isNixOS, isMacOS
, isIso, isHardware, nixpkgs, home-manager, ... }:
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
        overlays = [ ];
      };
      extraArgs = {
        inherit pkgs flakeInputs isIso isHardware dotfiles home-manager user
          hardware host system stateVersion;
        hostname = host + "-" + hardware;
      };

    in home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = extraArgs;
      modules = [
        ../modules/nix.nix
        ../home/default.nix
        ./${host}/home.nix
        ../user/${user}/default.nix
        ../hardware/${hardware}/default.nix
      ];
    };

  userPermutedHosts =
    lib.concatMap (user: map (host: host // user) hosts) users;
  hardwarePermutedHosts = lib.concatMap
    (hardware: map (permutation: permutation // hardware) userPermutedHosts)
    hardwares;
  systemsPermutedHosts = lib.concatMap
    (system: map (permutation: permutation // system) hardwarePermutedHosts)
    systems;
  permutedHosts = systemsPermutedHosts;

  /* We have a list of sets.
     Map each element of the list applying the mkHost function to its elements and returning a set in the listToAttrs format
     builtins.listToAttrs on the result
  */
in builtins.listToAttrs (map (mInput@{ user, host, hardware, system, ... }: {
  name = user + "-" + host + "-" + hardware + "-" + system;
  value = mkHost mInput isNixOS isMacOS isIso isHardware;
}) permutedHosts)
