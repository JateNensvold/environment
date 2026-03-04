{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "aerospace";
  version = "v0.18.2-Beta";
  src = pkgs.fetchurl {
    url =
      "https://github.com/nikitabobko/AeroSpace/releases/download/${version}/AeroSpace-${version}.zip";
    sha256 = "sha256-ljw4S+FnOSH/da6p0uRzevp6j8iAnB8BxT/LYKKW6ew=";
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
