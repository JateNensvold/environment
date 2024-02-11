{ config, lib, pkgs, settings_dir, ... }:
{


  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;

      userName = "Nate Jensvold";
      userEmail = "jensvoldnate@gmail.com";

      extraConfig = {
        core = {
          editor = "code --wait";
          pager = "delta";
        };
        diff = {
          tool = "default-difftool";
          colorMoved = "default";
        };
        difftool."default-difftool" = {
          cmd = "code --wait --diff $LOCAL $REMOTE";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = "true";
          light = "false";
        };
        mergetool."vscode" = {
          cmd = "code --wait --merge $REMOTE $LOCAL $BASE $MERGED";
        };
        merge = {
          conflictstyle = "diff3";
          tool = "vscode";
        };
        init = {
          defaultBranch = "master";
        };
        pull = {
          rebase = "true";
        };
        url."git@github.com" = {
          insteadOf = "https://github.com/";
        };
        credential = {
          helper = "!f() { /home/vscode/.vscode-server/bin/b380da4ef1ee00e224a15c1d4d9793e27c2b6302/node /tmp/vscode-remote-containers-855513c7-ab25-46f4-a4b7-a9c446b753ee.js git-credential-helper $*; }; f";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      history = {
        share = true;
      };

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
        #   List all files
        xa = "eza --group-directories-first -laa --time-style=long-iso";
        #   List files grouped by directory first
        xl = "eza --group-directories-first -l";
        #   List Tree of files
        xt = "eza -T";
        #   List all files in current directory and pipe to fzf
        xf = "eza --group-directories-first -l | fzf -m --header='[eza:files]'";
        #   List all files recursively and pipe to fzf
        ff = "erd -d logical -Hi --hidden --no-git --layout flat | fzf -m --header='[erd:files]'";
        #   Search all files using ripgrep
        sf = "rg -g '!.git' --hidden";
        # Nix search
        ns = "nix-env --query --available --attr-path";
        nv = "nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'";

        u = "utils";
        fe = "env | fzf -m --header='[find:env]'";
        reload = "reload-home-manager-config";
        c = "$EDITOR .";
        zx = "source ~/.extra_zshrc";
        zz = "$EDITOR ~/.zshrc";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource "${settings_dir}/dotfile_settings";
          file = ".p10k.zsh";
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.4.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
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
          "autojump"
          "copypath"
          "command-not-found"
          "fd"
          "docker"
          "direnv"
          "fzf"
          # fzf-tab
          "jsontools"
          "ssh-agent"
          "sudo"
          "web-search"
          "ripgrep"
          # "zsh-autosuggestions"
        ];
        # theme = "powerlevel10k/powerlevel10k";
      };

      initExtra = ''
        # Source 'real' zshrc file that is symlinked to the below location
        # source "$HOME/.extra_zshrc"
        # Updates to ZSH function paths
        fpath=(
            # For custom ZSH functions
            ~/.zfuncs
            $fpath
        )

        # ZSH functions
        autoload -Uz fp kp ks utils


        # Disable annoying beep sound in terminal
        unsetopt beep

        if [[ -n $SSH_CONNECTION ]]; then
            # Set vscode as default terminal editor when editing locally
            export EDITOR='vim'
        else
            # Be sure to quote $EDITOR path when using as default location of vscode is a path with space in it
            export VISUAL=$(which code | sed 's/ /\\ /g')
            export EDITOR="$VISUAL"
        fi
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      defaultCommand = "rg --files --no-ignore-vcs --hidden";
      defaultOptions = [ "--height=50%" "--min-height=15" "--reverse" ];
    };

    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
