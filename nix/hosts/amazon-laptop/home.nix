{ ... }: {
  imports = [ ./files/default.nix ../common/amazon.nix ];

  programs.zsh.oh-my-zsh = { plugins = [ "web-search" "macos" ]; };
}
