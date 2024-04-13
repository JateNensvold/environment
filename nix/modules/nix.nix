{ flakeInputs, lib, config, ... }:
with lib;
let

in {
  config = {
    # Command to link mutable files, copied from
    # https://github.com/ncfavier/config/blob/ea5562881e66cba102f017a68c22db7dcfccc48d/modules/nix.nix
    lib.meta = {
      configPath = "${config.home.homeDirectory}/environment/dotfiles";
      mkMutableSymlink = path:
        config.lib.file.mkOutOfStoreSymlink (config.lib.meta.configPath
          + removePrefix (toString flakeInputs.self) (toString path));
    };
  };
}
