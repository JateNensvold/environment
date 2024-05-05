{ user, host, hardware, ... }:
let
  modulePath = "./modules/";
  hostPath = "./hosts/";
in {

  xdg.configFile."nix/nix.conf ".text = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    ./${modulePath}/home/default.nix
    ./${modulePath}/home/packages.nix
    ./${hostPath}/${host}/home.nix
    ./${modulePath}/shared/user/${user}/default.nix
    ./${modulePath}/shared/hardware/${hardware}/default.nix
  ];

  # programs.zsh.initExtra = ''
  #   # Source brew path, should be present if system was setup by bash https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh
  #   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  # '';
}
