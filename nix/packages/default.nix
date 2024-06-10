# final: # package set with all overlays applied, a "fixed" point
# prev: # state of the package set before applying this overlay
# https://nixos.wiki/wiki/Overlays
final: prev: {
  custom = {
    # list of custom programs to add in pkgs
    wezterm = prev.callPackage ./pkgs/wezterm { };
    aerospace = prev.callPackage ./pkgs/aerospace { };
    unocss-lsp = prev.callPackage ./pkgs/unocss-lsp { };
    cfn-lint = prev.python3.pkgs.callPackage ./pkgs/cfn-lint { };
    taplo = prev.callPackage ./pkgs/taplo { };

    # get sha256 using nix-prefetch-url or nix-prefech-github
  };
}
