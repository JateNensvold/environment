{ config, lib, pkgs, dotfiles, ... }: {
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
        interactive = { diffFilter = "delta --color-only"; };
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
        init = { defaultBranch = "master"; };
        pull = { rebase = "true"; };
        url."git@github.com:" = { insteadOf = "https://github.com/"; };
        credential = {
          helper =
            "!f() { /home/vscode/.vscode-server/bin/b380da4ef1ee00e224a15c1d4d9793e27c2b6302/node /tmp/vscode-remote-containers-855513c7-ab25-46f4-a4b7-a9c446b753ee.js git-credential-helper $*; }; f";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      history = { share = true; };

      sessionVariables = { EDITOR = "vim"; };

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
        ff =
          "erd -d logical -Hi --hidden --no-git --layout flat | fzf -m --header='[erd:files]'";
        #   Search all files using ripgrep
        sf = "rg -g '!.git' --hidden";
        sa = "alias | fzf";
        # Nix search
        ns = "nix-env --query --available --attr-path";
        nv = "nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'";

        x2 = "exa --tree --level=2";
        x3 = "exa --tree --level=3";
        x4 = "exa --tree --level=4";
        x = "x2";

        u = "utils";
        fe = "env | fzf -m --header='[find:env]'";
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
          "autojump"
          "copypath"
          "command-not-found"
          "direnv"
          "fd"
          "fzf"
          "jsontools"
          "ssh-agent"
          "sudo"
          "ripgrep"
        ];
      };

      initExtra = ''
        # Updates to ZSH function paths
        fpath=(
            # For custom ZSH functions
            ~/.zfuncs
            $fpath
        )
        # Add keybind for sessionizer
        bindkey -s ^f "tmux-sessionizer\n"
        # ZSH functions
        autoload -Uz ~/.zfuncs/*(:t)

        # fzf-tab does not work without this
        enable-fzf-tab

        # Disable annoying beep sound in terminal
        unsetopt beep
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

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [ "--group-directories-first" "--header" ];
    };
  };
}
