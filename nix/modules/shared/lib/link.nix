{ flakeInputs, lib, config, ... }: {
  # Command to link mutable files, copied from
  # https://github.com/ncfavier/config/blob/ea5562881e66cba102f017a68c22db7dcfccc48d/modules/nix.nix
  mkMutableSymlink = path:
    lib.file.mkOutOfStoreSymlink
    ("${config.home.homeDirectory}/environment/dotfiles"
      + lib.removePrefix (lib.toString flakeInputs.self) (lib.toString path));
}
