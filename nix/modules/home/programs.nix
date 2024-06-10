{ my-lib, ... }:
let
  programPath = "../../programs";
  dotfilePath = "../../../dotfiles";
  ohMyPoshPath = "${dotfilePath}/oh-my-posh";
  inherit (my-lib.my) mapModulesL;
in {

  imports = mapModulesL (toString ./${programPath}) import;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    direnv = {
      enable = true;
      # breaks ZSH trap int
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      # breaks ZSH trap int
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" "--header" ];
    };

    fzf = {
      enable = true;
      # breaks ZSH trap int
      enableZshIntegration = true;
      defaultCommand = "rg --files --no-ignore-vcs --hidden";
      defaultOptions = [ "--height=50%" "--min-height=15" "--reverse" ];
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings =
        builtins.fromTOML (builtins.readFile ./${ohMyPoshPath}/prompt.toml);
    };
  };
}
