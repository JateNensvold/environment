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
      { path = "${pkgs.spotify}/Applications/Spotify.app"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app"; }
      { path = "/Applications/Slack.app"; }
      {
        path = "/Applications/Firefox.app";
      }
      # { path = "/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app"; }
      { path = "/Applications/Microsoft Outlook.app"; }
      { path = "/Applications/Amazon Chime.app"; }
    ];
  };
}
