{ config, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfilePath = "${config.home.homeDirectory}/environment/dotfiles";
in {
  # Link work specific nvim files into nvim source
  home.file."environment/dotfiles/nvim/default/lua/tosh-vim/lazy/home-codium.lua".source =
    link "${dotfilePath}/nvim/home/codium.lua";
}
