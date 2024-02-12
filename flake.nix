{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

      in
      {
        # The default shell
        devShells.default = pkgs.mkShell {
          PWSH_PATH = "${pkgs.powershell}/bin/pwsh";
          packages = with pkgs; [
            # Nix development packages
            nixpkgs-fmt
            rnix-lsp
            # VSCode extension packages
            powershell
            shellcheck
          ];
        };
      });
}
