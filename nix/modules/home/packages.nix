{ pkgs, stablePkgs, ... }:

with pkgs;
[
  # Tools
  ansible
  autojump
  # generates .cache and compile_commands.json files required by clangd
  bear
  bubblewrap
  claude-code
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
  ripgrep
  rustscan
  shellcheck
  sl
  slirp4netns
  sqlite
  tealdeer
  tmux
  unzip
  util-linux
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
  nodePackages.bash-language-server # bash, sh
  nodePackages.cspell # spelling
  nodePackages.typescript-language-server # js/ts
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
] ++ ([
  # custom packages
])
