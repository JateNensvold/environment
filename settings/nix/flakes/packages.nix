{ pkgs, username, importType}:

let
  userPackagesPath = ./users +"/${username}/${importType}.nix";

  nixTools = with pkgs; [
    ansible
    autojump
    cheat
    exa
    delta
    dogdns
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
  ] ++ (if builtins.pathExists (userPackagesPath) then import userPackagesPath { inherit pkgs; } else []);
in
nixTools
