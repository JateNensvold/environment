{ pkgs, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "taplo";
  version = "0.13.1";
  src = fetchFromGitHub {
    owner = "tamasfe";
    repo = "taplo";
    rev = "acec15f897cb57fc33999779f875db58fd89945d";
    hash = "sha256-NjjRDvmZwYAcn0W5qnxS1Qr8DaOE93XNr6q57uvB2LE=";
  };
  cargoHash = "sha256-dzG+fzlaxOI+sxQJ2OH0AXSW1JhGumNIc4gTa4+4JO8=";
  buildFeatures = [ "lsp" ];
  buildInputs = [ pkgs.openssl ] ++ pkgs.lib.optionals (pkgs.stdenv.isDarwin)
    [ pkgs.darwin.apple_sdk.frameworks.SystemConfiguration ];
}
