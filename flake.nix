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
          shellHook = ''
            NOCOLOR='\033[0m'
            RED='\033[0;31m'

            source ./scripts/ubuntu/install.sh
            ssh_support
            ssh_status=$?

            if [ ''$ssh_status -eq 1 ];
            then
              printf "''${RED}%s''${NOCOLOR}\n" "Github SSH support not detected, add a private key to ~/.ssh, or follow the directions in this link
              https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
            fi
          ''
          ;
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
