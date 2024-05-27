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
    ++ (with pkgs; [ custom.unocss-lsp ]);

  # programs.zsh.initExtra = ''
  #   # Source brew path, should be present if system was setup by bash https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh
  #   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  # '';
}
