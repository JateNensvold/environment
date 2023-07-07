{ pkgs }:

let
  nixTools = with pkgs; [
    autojump
    cheat
    exa
    delta
    erdtree
    fzf
    fd
    git
    git-crypt
    jq
    nix-prefetch-github
    ripgrep
    shellcheck
    sl
    tealdeer
    # ZSH
    zsh
    oh-my-zsh
    zsh-powerlevel10k
  ];
in
nixTools
