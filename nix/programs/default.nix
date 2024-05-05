final: prev: {
  custom = {
    # list of custom programs to add in pkgs
    wezterm = prev.callPackage ./pkgs/wezterm { };
  };
}
