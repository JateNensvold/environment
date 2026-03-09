{ pkgs, ... }:
let modulePath = "../../../modules";
in {
  imports = [
    # import dock util
    ./${modulePath}/darwin/dock
  ];

  local = {
    dock.enable = true;
    dock.entries = [
      { path = "${pkgs.custom.wezterm}/Applications/WezTerm.app"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app"; }
    ];
  };
}
