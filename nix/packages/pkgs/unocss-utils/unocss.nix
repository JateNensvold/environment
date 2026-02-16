{ lib, stdenv, fetchFromGitHub, fetchPnpmDeps, pnpmConfigHook, nodejs
, makeBinaryWrapper, pnpm }:

stdenv.mkDerivation rec {
  pname = "unocss";
  version = "0.62.4";

  src = fetchFromGitHub {
    owner = "unocss";
    repo = "unocss";
    rev = "v${version}";
    hash = "sha256-bY51oSBAZKRcMdwT//PI6iHljSJ0OkTYCt93cHhbKXA=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    hash = "sha256-9UigZ7dGq3lFw5/vtQMZifHv4Ro/9LwG//aYTeBWodg=";
    fetcherVersion = 2;
  };

  nativeBuildInputs = [ nodejs pnpmConfigHook makeBinaryWrapper pnpm ];

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
