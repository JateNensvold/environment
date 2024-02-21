{ config, lib, pkgs, username, importType, ... }:

{
  home.packages = with pkgs; [
    ansible
    autojump
    cheat
    curl
    delta
    dogdns
    erdtree
    fzf
    fd
    git
    git-crypt
    httpie
    jq
    # Install lld
    llvmPackages.bintools
    nix-prefetch-github
    ripgrep
    # Needed by brew
    ruby
    rustscan
    shellcheck
    sl
    tealdeer
  ];
}
