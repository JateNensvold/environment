{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "aerospace";
  version = "v0.10.0-Beta";
  src = pkgs.fetchurl {
    url =
      "https://github.com/nikitabobko/AeroSpace/releases/download/v0.10.0-Beta/AeroSpace-v0.10.0-Beta.zip";
    sha256 = "1742xbf1jlfr9w341akwxd0j029kk6qwvkk7ra3n492idk790hzc";
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
