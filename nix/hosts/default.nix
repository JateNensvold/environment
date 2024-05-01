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
          #     # sometimes it is useful to pin a version of some tool or program.
          #     # this can be done in " overlays/pinned.nix "
          #     (import ../overlays/pinned.nix)
        ];
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

      extraArgs = {
        inherit pkgs stablePkgs flakeInputs isIso isHardware dotfiles
          home-manager user hardware host system stateVersion;
        hostname = host + "-" + hardware;
      };

    in if isMacOS then
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = extraArgs;
        modules = [
          ../modules/darwin/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraArgs;
            home-manager.users."${user}" = {
              imports = [
                ../modules/shared/nix
                ../modules/home/default.nix
                ./${host}/home.nix
                ../modules/shared/user/${user}/default.nix
                ../modules/shared/hardware/${hardware}/default.nix
              ];
            };
          }
        ];
      }
    else
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = extraArgs;
        modules = [
          ../modules/shared/nix
          ../modules/home/default.nix
          ./${host}/home.nix
          ../modules/shared/user/${user}/default.nix
          ../modules/shared/hardware/${hardware}/default.nix
        ];
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
