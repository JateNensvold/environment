{ user, host, hardware, pkgs, stablePkgs, ... }:
let
  modulePath = "./modules/";
  hostPath = "./hosts/";
in {

  xdg.configFile."nix/nix.conf ".text = ''
    experimental-features = nix-command flakes
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
      custom.unocss
      custom.unocss-lsp
    ]);
}
