{ pkgs, ... }: {
  programs.zsh.oh-my-zsh = { plugins = [ "web-search" "macos" ]; };
  imports = [
    # setup file links specific to this host
    ./files/default.nix
  ];
  home.packages = with pkgs;
    [
      # packages only for this host
      spotify
      obsidian
    ] ++ (with pkgs; [ custom.wezterm custom.aerospace ]);

  home.sessionPath = [ "/opt/facebook/bin/" "/usr/local/bin/" ];

}
