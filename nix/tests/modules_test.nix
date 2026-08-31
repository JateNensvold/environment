let
  lib = import ./test-lib.nix;
  attrs = import ../lib/attrs.nix { inherit lib; };
  modules = import ../lib/modules.nix {
    inherit lib;
    self = { inherit attrs; };
  };
  fixtures = ./fixtures/modules;
  baseName = path: builtins.baseNameOf (toString path);
in
[
  {
    name = "mapModules includes Nix files and directories with defaults";
    actual = modules.mapModules fixtures baseName;
    expected = {
      child = "child";
      visible = "visible.nix";
    };
  }
  {
    name = "mapModules excludes defaults, private entries, and unrelated files";
    actual = builtins.attrNames (modules.mapModules fixtures baseName);
    expected = [
      "child"
      "visible"
    ];
  }
  {
    name = "mapModulesL returns the discovered module values";
    actual = modules.mapModulesL fixtures baseName;
    expected = [
      "child"
      "visible.nix"
    ];
  }
  {
    name = "mapModulesRec preserves the visible directory hierarchy";
    actual = modules.mapModulesRec fixtures baseName;
    expected = {
      child = {
        extra = "extra.nix";
      };
      nested = {
        leaf = "leaf.nix";
      };
      visible = "visible.nix";
    };
  }
  {
    name = "mapModulesRecL flattens recursively discovered module paths";
    actual = modules.mapModulesRecL fixtures baseName;
    expected = [
      "child"
      "visible.nix"
      "extra.nix"
      "leaf.nix"
    ];
  }
]
