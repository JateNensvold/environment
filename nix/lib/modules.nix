{ self, lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (lib)
    id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair
    removeSuffix;
  inherit (self.attrs) mapFilterAttrs;
in rec {
  # perform a map operation on all directory entries inside the provided directory path
  mapModules = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" && pathExists "${path}/default.nix" then
        nameValuePair n (fn path)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null) (readDir dir);

  # mapModules and convert result to a list
  mapModulesL = dir: fn: attrValues (mapModules dir fn);

  # recursivly perform a map operation on all directory entries inside the provided
  #  directory path, performing the operation again on any recursive directories
  mapModulesRec = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (n: v:
      let path = "${toString dir}/${n}";
      in if v == "directory" then
        nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null) (readDir dir);

  # mapMudulesRec and convert result to a list
  mapModulesRecL = dir: fn:
    let
      dirs = mapAttrsToList (k: _: "${dir}/${k}")
        (filterAttrs (n: v: v == "directory" && !(hasPrefix "_" n))
          (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRecL d id) dirs);
    in map fn paths;
}
