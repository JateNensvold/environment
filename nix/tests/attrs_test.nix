let
  lib = import ./test-lib.nix;
  attrs = import ../lib/attrs.nix { inherit lib; };
in
[
  {
    name = "attrsToList returns sorted name-value pairs";
    actual = attrs.attrsToList {
      beta = 2;
      alpha = 1;
    };
    expected = [
      {
        name = "alpha";
        value = 1;
      }
      {
        name = "beta";
        value = 2;
      }
    ];
  }
  {
    name = "attrsToList handles an empty set";
    actual = attrs.attrsToList { };
    expected = [ ];
  }
  {
    name = "mapFilterAttrs maps names and values before filtering";
    actual =
      attrs.mapFilterAttrs (_: value: value >= 4)
        (name: value: {
          name = "${name}-mapped";
          value = value * 2;
        })
        {
          alpha = 1;
          beta = 2;
          gamma = 3;
        };
    expected = {
      beta-mapped = 4;
      gamma-mapped = 6;
    };
  }
  {
    name = "genAttrs' builds attributes from transformed values";
    actual = attrs.genAttrs' [ "a" "bbb" ] (value: {
      name = value;
      value = builtins.stringLength value;
    });
    expected = {
      a = 1;
      bbb = 3;
    };
  }
  {
    name = "anyAttrs matches names and values";
    actual = attrs.anyAttrs (name: value: name == "beta" && value == 2) {
      alpha = 1;
      beta = 2;
    };
    expected = true;
  }
  {
    name = "anyAttrs returns false for an empty set";
    actual = attrs.anyAttrs (_: _: true) { };
    expected = false;
  }
  {
    name = "countAttrs counts matching values";
    actual = attrs.countAttrs (_: value: value > 1) {
      alpha = 1;
      beta = 2;
      gamma = 3;
    };
    expected = 2;
  }
]
