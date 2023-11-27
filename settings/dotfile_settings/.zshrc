#!/etc/zshrc
# shellcheck disable=all
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

export JAVA_HOME=$(dirname $(dirname $(realpath /usr/bin/java)))
export PATH=$JAVA_HOME/bin:$PATH

# Updates to ZSH function paths
fpath=(
    # For custom ZSH functions
    ~/.zfuncs
    # For zsh completion scripts
    # "$HOME/completion"
    $fpath
)

# ZSH functions
autoload -Uz fp kp ks utils

# Directory custom oh-my-zsh extensions are installed in
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    autojump
    copypath
    command-not-found
    fd
    docker
    direnv
    fzf
    # fzf-tab
    jsontools
    nix-shell
    ssh-agent
    sudo
    web-search
    ripgrep
    zsh-autosuggestions
)


source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    # Set vscode as default terminal editor when editing locally
    export EDITOR='vim'
else
    # Be sure to quote $EDITOR path when using as default location of vscode is a path with space in it
    export VISUAL=$(which code | sed 's/ /\\ /g')
    export EDITOR="$VISUAL"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes.

alias ga="git add ."
alias gc="git commit -m ${1}"
alias gd="git diff"
alias gdt="git difftool"
alias gmt="git mergetool"
alias gp="git push ${1} ${2}"
alias gco="git checkout ${1} ${2}"
alias gpl="git pull ${1} ${2}"
alias grb="git rebase -i ${1} ${2}"
alias gs="git status"
alias gl="git ls-files ${1} | xargs wc -l"

#   List all files
alias xa="exa --group-directories-first -laa --time-style=long-iso"
#   List files grouped by directory first
alias  xl="exa --group-directories-first -l"
#   List Tree of files
alias xt="exa -T"
#   List all files in current directory and pipe to fzf
alias xf="exa --group-directories-first -l | fzf ${FZF_DEFAULT_OPTS} -m --header='[exa:files]'"
#   List all files recursivly and pipe to fzf
alias ff="erd -d logical -Hi --hidden --no-git --layout flat | fzf ${FZF_DEFAULT_OPTS} -m --header='[erd:files]'"
#   Search all files using ripgrep
alias sf="rg -g '!.git' --hidden"

# Nix search
alias ns="nix-env --query --available --attr-path"
alias nv="nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version'"

alias u="utils"
alias fe="env | fzf ${FZF_DEFAULT_OPTS} -m --header='[find:env]'"
alias reload="reload-home-manager-config"
alias c="$EDITOR ."
alias zx="source ~/.extra_zshrc"
alias zz="$EDITOR ~/.extra_zshrc"


# Steam locomotive
alias sl="sl -ea"

# Persist zsh command history between sessions
setopt appendhistory
# Disable annoying beep sound in terminal
unsetopt beep

# Load custom Powerlevel0k prompt
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# added by Nix installer
if [ -e /home/tosh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/tosh/.nix-profile/etc/profile.d/nix.sh; fi

# Added by Home manager https://rycee.gitlab.io/home-manager/index.html
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"


# The following is added to access amazon internal tools
#########################
export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
export AUTO_TITLE_SCREENS="NO"
# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false
export AWS_EC2_METADATA_DISABLED=true

alias e=emacs
alias bb=brazil-build

alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use -p'
alias bwscreate='bws create -n'
alias brc=brazil-recursive-cmd
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'

export PATH=$HOME/.toolbox/bin:$PATH
