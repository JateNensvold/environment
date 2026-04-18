{ pkgs, stablePkgs, ... }:

with pkgs;
[
  # Tools
  ansible
  autojump
  # generates .cache and compile_commands.json files required by clangd
  bear
  claude-code
  codex
  chafa
  cheat
  # add realpath for darwin systems
  coreutils
  curl
  cmake
  cmatrix # hacker man
  delta
  doggo
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
  pstree
  ripgrep
  rustscan
  shellcheck
  sl
  sqlite
  tealdeer
  tmux
  unzip
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
  rbenv
  rustup
  # Needed by brew
  ruby

  # LSP servers
  docker-compose-language-service # docker compose
  dockerfile-language-server # dockerfile
  htmx-lsp # htmx
  lua-language-server # lua
  markdownlint-cli # markdown
  nil # nix
  bash-language-server # bash, sh
  cspell # spelling
  typescript-language-server # js/ts
  pyright # python
  sqls # sql
  taplo # toml
  vscode-langservers-extracted # html/css/json/ESLint
  clang-tools # c++ lsp

  # Formatters
  black # python
  djlint # template files
  nixfmt # nix
  prettierd # html/js/css
  shfmt # bash, sh
  sqlfluff # sql
  yamlfmt # yaml

  # Linters
  ansible-lint
]
++ lib.optionals stdenv.isLinux [
  bubblewrap
  slirp4netns
  util-linux
  xclip
]
++ ([
  # custom packages
])
