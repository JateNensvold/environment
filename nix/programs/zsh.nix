{ pkgs, lib, ... }: {

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = { enable = true; };
      syntaxHighlighting.enable = true;
      history = { share = true; };

      shellAliases = {
        lg = "lazygit";
        gau = "git add -u .";
        gc = "git commit -m";
        gd = "git diff";
        gds = "git diff --staged";
        gdt = "git difftool";
        gmt = "git mergetool";
        gs = "git status";
        gl = "git ls-files | xargs wc -l";
        # Steam locomotive
        sl = "sl -ea";

        xt = "eza -T";
        x2 = "eza --tree --level=2";
        x3 = "eza --tree --level=3";
        x4 = "eza --tree --level=4";
        x = "x2";

        vv =
          "var=$(fd | fzf --header='[vim:file]') && full_var=$(realpath $var) && change-location $var && vim $full_var ";
        fe = "export | fzf --header='[find:env]'";

        sf = "rg -g '!.git' --hidden";
        sa = "alias | fzf --header='[search:alias]'";
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
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
            sha256 = "gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
          };
        }
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "command-not-found"
          # breaks ZSH TRAPINT
          "ssh-agent"
          "sudo"
        ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [ "autojump" ];
      };
      # zsh sessionVariables allow for more variables types than home.sessionVariables which are restricted to only strings/integers
      sessionVariables = {
        # set list of strings to be parsed by tmux-sessionizer
        TMUX_SESSIONIZER_PATHS = [
          # mapping between path and path depth
          "~:1"
          "~/projects:1"
          "~/workspace:2"
        ];
      };

      initExtra = ''
        # unset __HM_ZSH_SESS_VARS_SOURCED to allow .zshenv variables to get set
        # https://github.com/nix-community/home-manager/issues/2751
        unset __HM_ZSH_SESS_VARS_SOURCED
        . ~/.zshenv

        # Updates to ZSH function paths
        fpath=(
            # For custom ZSH functions
            ~/.zfuncs
            $fpath
        )
        # load ZSH functions
        autoload -Uz ~/.zfuncs/*(:t)

        # load zsh widgets for keybinds
        zle -N tsession
        zle -N ff

        # VI-mode plugin will auto execute this
        function zvm_after_init() {
          bindkey -M vicmd '^F' tsession
          bindkey -M vicmd 'H' vi-digit-or-beginning-of-line
          bindkey -M vicmd 'L' vi-end-of-line

          bindkey '^F' tsession
          # bindkey -s '^F' 'tsession\n'
          bindkey '^R' fzf-history-widget
          bindkey "^P" ff
        }

        # Disable annoying beep sound in terminal
        unsetopt beep
      '';
    };
  };
}
