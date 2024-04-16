{ config, lib, pkgs, username, importType, ... }:

{
  home.packages = with pkgs; [
    # Tools
    ansible
    autojump
    # cargo
    cheat
    curl
    cmake
    cmatrix # hacker man
    delta
    dogdns
    erdtree
    fzf
    fd
    git
    git-crypt
    git-filter-repo
    lazygit
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
    #Nvim plugins
    vimPlugins.telescope-fzf-native-nvim
    # Tmux plugins
    tmuxPlugins.resurrect
    tmuxPlugins.continuum
    # Nix tools
    nix-prefetch-github
    # Install lld
    llvmPackages.bintools
    # Runtimes
    nodejs_21
    python3
    rustup
    # Needed by brew
    ruby

    # LSP servers
    nil # nix
    nodePackages.bash-language-server # bash,  sh
    docker-compose-language-service # docker compose
    dockerfile-language-server-nodejs # dockerfile
    sqls # sql
    lua-language-server # lua
    nodePackages.pyright # python
    ansible-language-server

    # Formatters
    shfmt # bash, sh
    eslint_d # javascript
    nixfmt-classic # nix
    sqlfluff # sql
    black # python
    yamlfmt # yaml

    # Linters
    ansible-lint
  ];
}
