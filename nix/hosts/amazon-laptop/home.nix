{ pkgs, ... }: {
  programs.zsh.oh-my-zsh = { plugins = [ "web-search" "macos" ]; };
  imports = [
    # setup file links specific to this host
    ./files/default.nix
    # setup utils common to all amazon hosts
    ../common/amazon.nix
  ];
  home.packages = with pkgs;
    [
      # packages only for this host
      spotify
      obsidian
    ] ++ (with pkgs; [ custom.wezterm ]);

  # https://builderhub.corp.amazon.com/docs/builder-toolbox/user-guide/getting-started.html#install-toolbox-macos
  # manually install the following tools from self service tools(App)
  # -toolbox
  # - wssh
  # - SSH Kerberos

  # toolbox may fail and require an entry in /etc/synthetic.conf that it does not have permission for
  # https://stackoverflow.com/questions/58396821/what-is-the-proper-way-to-create-a-root-sym-link-in-catalina
  # - sudo chown $USER /etc/synthetic.conf
  # - restart computer
  # - toolbox install bemol barium brazilcli cr

  # enable git off vpn
  # - https://sage.amazon.dev/posts/1593689?t=7
  # Install WSSH, setup bastion, and kerberos
  # - https://w.amazon.com/bin/view/WSSH/
  # - https://sage.amazon.dev/posts/1297827?t=7#1320783
  # Generate a new SSH key and add to SSH keychain
  # - https://w.amazon.com/bin/view/NextGenMidway/UserGuide#Mac

  # Other manual setups
  # - Log into apple account jensvold@amazon.com
  # - Setup amphetamine manually, it does not support config files
  # - Manually enable notifications for apps(slack/email/chime) in settings -> notifications -> App Name

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };
}
