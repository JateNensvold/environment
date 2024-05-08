{ pkgs, user, ... }: {
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
    ] ++ (with pkgs; [ custom.wezterm custom.aerospace ]);

  programs = {
    ssh = {
      enable = true;

      # Host clouddesk
      #     HostName dev-dsk-jensvold-2a-6b604d28.us-west-2.amazon.com
      #     User jensvold
      #     ProxyCommand=wssh proxy %h
      matchBlocks = {
        clouddesk = {
          hostname = "dev-dsk-jensvold-2a-6b604d28.us-west-2.amazon.com";
          user = "${user}";
          proxyCommand = "wssh proxy %h";
        };
      };
      extraConfig = ''
        ### Start of WSSH Config Block ###

        ##############################################################################################
        ### ****                             IMPORTANT NOTICE                                 **** ###
        ### **** PLEASE DO NOT PUT ANY CUSTOM CONFIGURATIONS IN BETWEEN THE WSSH CONFIG BLOCK **** ###
        ### ****                WHEN WSSH UNINSTALLS THIS BLOCK WILL BE REMOVED              **** ###
        #############################################################################################

        ## Start of CNAME and SSH alias configs - PLEASE DO NOT EDIT THIS LINE ##

        ## End of CNAME and SSH alias configs ##

        # The following config is added by WSSH setup script to configure off-VPN dev-dsk access.
        Host dev-dsk-*.amazon.com
          ProxyCommand=/usr/local/bin/wssh proxy %h
          ServerAliveInterval 15
          ServerAliveCountMax 44
          User jensvold


        # The following config is added by WSSH setup script to configure off-VPN SSH access.
        Host *.corp.amazon.com
          ProxyCommand=/usr/local/bin/wssh proxy %h
          ServerAliveInterval 15
          ServerAliveCountMax 44
          User jensvold


        # The following config is added by WSSH setup script to configure off-VPN Git access.
        Host git.amazon.com
          ProxyCommand=/usr/local/bin/wssh proxy %h --port=%p
          User jensvold

        Host github.audible.com
          ProxyCommand=/usr/local/bin/wssh proxy %h --port=%p
          User git

        Match all

        ### End of WSSH Config Block ###

        # Enable Kerb Forwarding
        Host git.amazon.com
        	GSSAPIAuthentication yes
        	GSSAPIDelegateCredentials yes

        Host clouddesk
            HostName dev-dsk-jensvold-2a-6b604d28.us-west-2.amazon.com
            User jensvold
            ProxyCommand=wssh proxy %h

        # Amazon Security Bastions SSH Config
        Include ~/.ssh/bastions-config
      '';
    };
  };
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

  # firefox setup
  # - export firefox profile
  #     - find profile at 'about:support'
  #     - cd /Users/jensvold/Library/Application Support/Firefox/Profiles/" && zip -r firefox.zip buf8y2d5.default-esr"
  # scp file to clouddesk
  #		- scp firefox.zip clouddesk:~
  # scp file to new laptop
  #		- scp clouddesk:~/firefox.zip .
  #     - find profile directory on new laptop at 'about:support' and clear directory
  #     - unzip firefox.zip -d "/Users/jensvold/Library/Application Support/Firefox/Profiles/4mexaxbe.default-release"

  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox-bin;
  # };
}
