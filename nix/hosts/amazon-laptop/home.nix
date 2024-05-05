{ pkgs, ... }: {
  programs.zsh.oh-my-zsh = { plugins = [ "web-search" "macos" ]; };
  imports = [ ./files/default.nix ../common/amazon.nix ];
  home.packages = with pkgs;
    [ spotify obsidian ] ++ (with pkgs; [ custom.wezterm ]);
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };
}
