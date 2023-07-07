{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Allow default.nix and shell.nix to import this flake
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };

      in
      {
        # The default shell
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            rnix-lsp
            powershell
            shellcheck
            nixpkgs-fmt
          ];
        };

        # this shell only used in CI, so it should contain minimal
        # pkgs to avoid building and caching things that arent needed
        devShells.lint = pkgs.mkSHell
          {
            packages = with pkgs; [
              nixpkgs-fmt
              shellcheck
              git
              semgrep
              nix
            ];
          };

      });
}
