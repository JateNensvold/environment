{ pkgs, stablePkgs, ... }:

with pkgs;
[
  # Tools
  ansible
  autojump
  cheat
  # add realpath for darwin systems
  coreutils
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
  oh-my-posh
  ripgrep
  rustscan
  shellcheck
  sl
  sqlite
  tealdeer
  tmux
  xclip
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
  nodejs_22
  stablePkgs.python3
  go
  rustup
  # Needed by brew
  ruby

  # LSP servers
  ansible-language-server
  docker-compose-language-service # docker compose
  dockerfile-language-server-nodejs # dockerfile
  htmx-lsp # htmx
  lua-language-server # lua
  markdownlint-cli # markdown
  nil # nix
  nodePackages.bash-language-server # bash, sh
  nodePackages.cspell # spelling
  nodePackages.typescript-language-server # js/ts
  pyright # python
  sqls # sql
  # taplo # toml
  vscode-langservers-extracted # html/css/json/ESLint

  # Formatters
  shfmt # bash, sh
  nixfmt-classic # nix
  sqlfluff # sql
  black # python
  yamlfmt # yaml
  prettierd # html/js/css

  # Linters
  ansible-lint
] ++ ([
  # custom packages
  pkgs.custom.cfn-lint
  pkgs.custom.taplo
])
