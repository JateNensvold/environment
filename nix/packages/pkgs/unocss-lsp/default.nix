{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "JateNensvold";
    repo = "unocss-flake";
    rev = "f4bc4ac6914b2cfc57c4b8be658d6cc91f39d004";
    sha256 = "sha256-1rUB+d+cijlafaw9RZzw+4Rr6kX2VaGaSg8pSnbdFN4=";
  };
  unocss-pkgs = pkgs.callPackage (src + "/pkgs/unocss-cli") { };
in unocss-pkgs.unocss-language-server
