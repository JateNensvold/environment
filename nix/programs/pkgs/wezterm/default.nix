{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "wezterm";
  version = "20240203-110809-5046fc22";
  src = pkgs.fetchurl {
    url =
      "https://github.com/wez/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-macos-20240203-110809-5046fc22.zip";
    sha256 = "e77388cad55f2e9da95a220a89206a6c58f865874a629b7c3ea3c162f5692224";
  };
  nativeBuildInputs = [ unzip ];
  buildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r WezTerm.app "$out/Applications/"

    runHook postInstall
  '';
}
