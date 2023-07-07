{
  # followed these instructions https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/flake.nix
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = "tosh"; # $USER
      system = "x86_64-linux";  # x86_64-linux, aarch64-multiplatform, etc.
      stateVersion = "23.05";     # See https://nixos.org/manual/nixpkgs/stable for most recent

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          experimental-features = "nix-command flakes";
        };
      };

      homeDirPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "/${homeDirPrefix}/${username}";

    in
    {
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager build --flake .#your-username'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "tosh" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit homeDirectory username stateVersion; }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [ ./flakes/home.nix ];
        };
      };
    };
}
