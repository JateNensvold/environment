{ config, lib, pkgs, username, importType, ... }:

{
  home.packages = with pkgs; [
    ansible
    autojump
    cargo
    cheat
    curl
    delta
    dogdns
    erdtree
    fzf
    fd
    git
    git-crypt
    gnumake
    httpie
    jq
    # Install lld
    llvmPackages.bintools
    nix-prefetch-github
    nodejs_21
    ripgrep
    # Needed by brew
    ruby
    rustscan
    shellcheck
    sl
    tealdeer
    zip
  ];
}
