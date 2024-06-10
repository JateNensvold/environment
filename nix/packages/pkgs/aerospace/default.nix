{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  name = "aerospace";
  version = "v0.11.2-Beta";
  src = pkgs.fetchurl {
    url =
      "https://github.com/nikitabobko/AeroSpace/releases/download/${version}/AeroSpace-${version}.zip";
    sha256 = "05faqi9kma5w8d08fqb7dp38jjch40vq63kik3hqjpf0cpsa5acs";
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
