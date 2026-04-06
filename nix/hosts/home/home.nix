{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # claude-sandbox (requires bubblewrap, linux-only)
  programs.zsh.shellAliases.cs = "claude-sandbox";
  home.file.".local/home-bin".source = link "${dotfilePath}/scripts/bash/home";
  home.sessionPath = [ "$HOME/.local/home-bin" ];
}
