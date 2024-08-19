{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "aerospace";
  version = "v0.14.2-Beta";
  src = pkgs.fetchurl {
    url =
      "https://github.com/nikitabobko/AeroSpace/releases/download/${version}/AeroSpace-${version}.zip";
    sha256 = "07ww0aikjk1bjiz54rm1ynbk6qr4c27451mh8nykqh85b7khzqn4";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r AeroSpace.app "$out/Applications/"
    mkdir -p "$out/bin"
    cp -r ./bin/aerospace "$out/bin/"

    runHook postInstall
  '';
}
