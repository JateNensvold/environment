{ config, pkgs, homeDirectory, username, stateVersion, ... }: #, lib, ... }:
let
  packages = import ./packages.nix { inherit pkgs; };
  link = config.lib.file.mkOutOfStoreSymlink;
  settings_dir = "${homeDirectory}/environment/settings";
in
{
  home = {
    inherit homeDirectory packages username stateVersion;
    shellAliases = {
      reload-home-manager-config = "home-manager switch --flake ${settings_dir}/nix/#tosh";
    };
  };

  programs = import ./programs.nix { inherit pkgs; };

  # Static File
  home.file.".zfuncs".source = ../../dotfile_settings/zsh_scripts;
  home.file.".p10k.zsh".source = ../../dotfile_settings/.p10k.zsh;
  home.file.".config/cheat/conf.yml".source = ../../cheat/conf.yml;
  home.file.".inputrc".source = ../../dotfile_settings/.inputrc;

  # Dynamic File (needs to link to a full path to remain pure https://github.com/nix-community/home-manager/issues/2085)
  home.file.".extra_zshrc".source = link "${settings_dir}/dotfile_settings/.zshrc";
  home.file.".config/git/config".source = link "${settings_dir}/dotfile_settings/.gitconfig";

  # Dynamic folder
  home.file.".config/cheat/cheatsheets/personal".source = link "${settings_dir}/cheat/cheats";

  # File downloads
  home.file.".config/cheat/cheatsheets/community".source = pkgs.fetchFromGitHub
    {
      owner = "cheat";
      repo = "cheatsheet";
      rev = "36bdb99dcfadde210503d8c2dcf94b34ee950e1d";
      sha256 = "sha256-Afv0rPlYTCsyWvYx8UObKs6Me8IOH5Cv5u4fO38J8ns";
    };

  # Oh-my-zsh themes and plugins
  home.file."/.oh-my-zsh/custom/themes/powerlevel10k".source = pkgs.fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "20323d6f8cd267805a793dafc840d22330653867";
    sha256 = "ZDf8DAKNfeud+9MbZq8FBk272S8x1BI1BTcw48Qf8Cc=";
  };
  home.file.".oh-my-zsh/custom/plugins/fzf-tab".source = pkgs.fetchFromGitHub
    {
      owner = "Aloxaf";
      repo = "fzf-tab";
      rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
      sha256 = "gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
    };
  home.file.".oh-my-zsh/custom/plugins/zsh-autosuggestions".source = pkgs.fetchFromGitHub
    {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
      sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
    };
  home.file.".oh-my-zsh/custom/plugins/nix-shell".source = pkgs.fetchFromGitHub
    {
      owner = "chisui";
      repo = "zsh-nix-shell";
      rev = "227d284ab2dc2f5153826974e0094a1990b1b5b9";
      sha256 = "SrGvHsAJCxzi69CKNKKvItYUaAP7CKwRntsprVHBs4Y=";
    };

  # Enable services
  # service.<name>.enable = true
}
