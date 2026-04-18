{ user, host, hardware, pkgs, stablePkgs, ... }:
let
  modulePath = "./modules/";
  hostPath = "./hosts/";
in {

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    # Avoid "download buffer is full" warnings for large downloads.
    download-buffer-size = 524288000
  '';

  imports = [
    ./${modulePath}/home/default.nix
    ./${hostPath}/${host}/home.nix
    ./${modulePath}/shared/user/${user}/default.nix
    ./${modulePath}/shared/hardware/${hardware}/default.nix
  ];

  home.packages = [ ]
    ++ (import ./${modulePath}/home/packages.nix { inherit pkgs stablePkgs; })
    ++ (with pkgs; [
      # Disabled: upstream unocss packaging currently fails during eval/build.
      # custom.unocss
      # custom.unocss-lsp
    ]);
}
