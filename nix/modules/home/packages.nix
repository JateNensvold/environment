{ pkgs, stablePkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    ansible
    autojump
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
    sqlite
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
    stablePkgs.python3
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
    htmx-lsp # htmx
    nodePackages.typescript-language-server # js/ts

    # Formatters
    shfmt # bash, sh
    nixfmt-classic # nix
    sqlfluff # sql
    black # python
    yamlfmt # yaml
    prettierd # html/js/css

    # Linters
    ansible-lint
  ];
}