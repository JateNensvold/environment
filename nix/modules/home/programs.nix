{ pkgs, dotfiles, lib, ... }:
let programPath = "../../programs/";
in {

  imports = [ ./${programPath}/programs/git.nix ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = { enable = true; };
      syntaxHighlighting.enable = true;
      history = { share = true; };

      shellAliases = {
        ga = "git add .";
        gc = "git commit -m \${1}";
        gd = "git diff";
        gdt = "git difftool";
        gmt = "git mergetool";
        gp = "git push \${1} \${2}";
        gco = "git checkout \${1} \${2}";
        gpl = "git pull \${1} \${2}";
        grb = "git rebase -i \${1} \${2}";
        gs = "git status";
        gl = "git ls-files \${1} | xargs wc -l";
        # Steam locomotive
        sl = "sl -ea";

        xt = "eza -T";
        x2 = "eza --tree --level=2";
        x3 = "eza --tree --level=3";
        x4 = "eza --tree --level=4";
        x = "x2";

        ff = "var=$(fd | fzf --header='[find:file]') && change-location $var";
        vv =
          "var=$(fd | fzf --header='[vim:file]') && full_var=$(realpath $var) && change-location $var && vim $full_var ";
        fe = "env | fzf --header='[find:env]'";

        sf = "rg -g '!.git' --hidden";
        sa = "alias | fzf --header='[search:alias]'";
        se = "env | fzf --header='[search:env]'";
        sp = "home-manager packages | fzf --header='[search:packages]'";

        nv = "nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'";
        u = "utils";
        reload = "reload-home-manager-config && zx";

        c = ''"$EDITOR" .'';
        ce = "cd ~/environment";
        ze = ''"$EDITOR" ~/environment'';
        zx = "source ~/.zshrc";
        zz = ''"$EDITOR" ~/.config/nvim'';
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = "${dotfiles}/dotfile_settings";
          file = ".p10k.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
            sha256 = "gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
          };
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "copypath"
          "command-not-found"
          "direnv"
          "fd"
          "jsontools"
          "ssh-agent"
          "sudo"
          "ripgrep"
        ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [ "autojump" ];
      };

      initExtra = ''
        # Updates to ZSH function paths
        fpath=(
            # For custom ZSH functions
            ~/.zfuncs
            $fpath
        )
        # ZSH functions
        autoload -Uz ~/.zfuncs/*(:t)

        # Add keybind for sessionizer
        bindkey -s ^f "tmux-sessionizer\n"
        # Enable opening file in vim from terminal using fuzzy finder in vv
        bindkey -s ^p "vv\n"

        # fzf-tab does not work without this
        enable-fzf-tab

        # Disable annoying beep sound in terminal
        unsetopt beep
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      defaultCommand = "rg --files --no-ignore-vcs --hidden";
      defaultOptions = [ "--height=50%" "--min-height=15" "--reverse" ];
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      extraOptions = [ "--group-directories-first" "--header" ];
    };
  };
}
