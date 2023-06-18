# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add brew paths to environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Enable cheat autocompletion with fzf
export CHEAT_USE_FZF=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Updates to ZSH function paths
fpath=(
	# For custom ZSH functions
	~/.zfuncs
	# For zsh completion scripts
	"$HOME/completion"
	$fpath
	)
autoload -Uz bcp bip bup fp kp ks utils

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	autojump
	cheat
	copypath
	copyfile
	command-not-found
	fd
	docker
    fzf
	fzf-tab
	git
	jsontools
    ssh-agent
	sudo
	systemadmin
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
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

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

  alias u="utils"
  alias c="\"$EDITOR\" ."
  alias zx="source ~/.zshrc"
  alias zz="\"$EDITOR\" ~/.zshrc"

# Persist zsh command history between sessions
setopt appendhistory
# Disable annoying beep sound in terminal
unsetopt beep

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
