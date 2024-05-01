{ pkgs, stablePkgs, ... }: {

  home.packages = with pkgs; [
    # stablePkgs.wezterm
    spotify
    obsidian
  ];
}
