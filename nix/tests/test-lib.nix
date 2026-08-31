let
  inherit (builtins)
    attrNames
    concatLists
    filter
    length
    listToAttrs
    map
    stringLength
    substring
    ;
in
rec {
  nameValuePair = name: value: { inherit name value; };

  mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (attrNames attrs);

  mapAttrs' = f: attrs: listToAttrs (map (name: f name attrs.${name}) (attrNames attrs));

  filterAttrs =
    pred: attrs:
    listToAttrs (
      concatLists (
        map (
          name:
          let
            value = attrs.${name};
          in
          if pred name value then [ (nameValuePair name value) ] else [ ]
        ) (attrNames attrs)
      )
    );

  count = pred: values: length (filter pred values);
  id = value: value;

  hasPrefix =
    prefix: value:
    stringLength prefix <= stringLength value && substring 0 (stringLength prefix) value == prefix;

  hasSuffix =
    suffix: value:
    stringLength suffix <= stringLength value
    && substring (stringLength value - stringLength suffix) (stringLength suffix) value == suffix;

  removeSuffix =
    suffix: value:
    if hasSuffix suffix value then
      substring 0 (stringLength value - stringLength suffix) value
    else
      value;
}
