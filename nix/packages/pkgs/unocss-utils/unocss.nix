{ lib, stdenv, fetchFromGitHub, pnpm_9, nodejs, makeBinaryWrapper }:

stdenv.mkDerivation rec {
  pname = "unocss";
  version = "0.62.4";

  src = fetchFromGitHub {
    owner = "unocss";
    repo = "unocss";
    rev = "v${version}";
    hash = "sha256-bY51oSBAZKRcMdwT//PI6iHljSJ0OkTYCt93cHhbKXA=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    # hash = "sha256-N5/42kvcNNd9j2CacPFy98pB6eho3nNayQRGgWb+24g=";
    hash = "sha256-N5/42kvcNNd9j2CacPFy98pB6eho3nNayQRGgWb+24g=";
  };

  nativeBuildInputs = [ nodejs pnpm_9.configHook makeBinaryWrapper ];

  # The following links are missing after building unocss, disabling the broken symlink check
  # /lib/unocss/docs
  # /lib/unocss/interactive
  # /lib/unocss/playground
  # /lib/unocss/test/fixtures/vite-legacy-chunks
  dontCheckForBrokenSymlinks = true;

  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build --filter=cli

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/unocss}

    cp -r {packages,node_modules} $out/lib/unocss

    makeWrapper ${lib.getExe nodejs} $out/bin/unocss \
      --inherit-argv0 \
      --add-flags $out/lib/unocss/node_modules/@unocss/cli/bin/unocss.mjs

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "The instant on-demand atomic CSS engine";
    homepage = "https://github.com/unocss/unocss";
    license = licenses.mit;
    mainProgram = "unocss";
    platforms = platforms.all;
  };
}
