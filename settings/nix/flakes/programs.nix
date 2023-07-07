{ pkgs }:
{
  home-manager = {
    enable = true;
  };

  zsh = {
    enable = true;
    # Adds $ZSH environement variable
    oh-my-zsh = {
      enable = true;
    };

    initExtra = ''
      # Source 'real' zshrc file that is symlinked to the below location
      source "$HOME/.extra_zshrc"
    '';
  };

  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
