{ config, lib, pkgs, username, importType, ... }:

{
  home.packages = with pkgs; [
    # Tools
    ansible
    autojump
    cargo
    cheat
    curl
    cmake
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
    ripgrep
    rustscan
    shellcheck
    sl
    tealdeer
    tmux
    zip
    # Nix tools
    nix-prefetch-github
    # Install lld
    llvmPackages.bintools
    # Runtimes
    nodejs_21
    python3
    # Needed by brew
    ruby
    # LSP servers
    nil # nix
    nodePackages.bash-language-server # bash,  sh
    # Formatters
    shfmt # bash, sh
    eslint_d # javascript
    nixfmt # nix
  ];
}
