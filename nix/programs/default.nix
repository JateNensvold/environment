final: prev: {
  custom = {
    # list of custom programs to add in pkgs
    wezterm = prev.callPackage ./pkgs/wezterm { };
    aerospace = prev.callPackage ./pkgs/aerospace { };
    # get sha256 using nix-prefetch-url or nix-prefech-github
  };
}