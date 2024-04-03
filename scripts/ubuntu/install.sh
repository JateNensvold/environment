#!/usr/bin/env bash

{ # Prevent script running if partially downloaded

	set -eo pipefail

	NOCOLOR='\033[0m'
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	ORANGE='\033[0;33m'
	CYAN='\033[0;36m'

	header() {
		printf "${CYAN}%s${NOCOLOR}\n" "$@"
	}

	info() {
		printf "${GREEN}%s${NOCOLOR}\n" "$@"
	}

	warn() {
		printf "${ORANGE}%s${NOCOLOR}\n" "$@"
	}

	error() {
		printf "${RED}%s${NOCOLOR}\n" "$@"
	}
	# Lifted from https://github.com/kalbasit/shabka/blob/8f6ba74a9670cc3aad384abb53698f9d4cea9233/os-specific/darwin/setup.sh#L22
	sudo_prompt() {
		echo
		header "We are going to check if you have 'sudo' permissions."
		echo "Please enter your password for sudo authentication"
		sudo -k
		sudo echo "sudo authentication successful!"
		while true; do
			sudo -n true
			sleep 60
			kill -0 "$$" || exit
		done 2>/dev/null &
	}

	install_nix() {
		echo
		header "Installing Nix"
		command -v nix >/dev/null || {
			warn "'Nix' is not installed. Installing..."
			NIX_INSTALL_VERSION="v0.11.0"
			NIX_BUILD_GROUP_ID=$1
			if [[ $NIX_BUILD_GROUP_ID ]]; then
				curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/${NIX_INSTALL_VERSION} | sh -s -- install --no-confirm --nix-build-group-id "$NIX_BUILD_GROUP_ID"
			else
				curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/${NIX_INSTALL_VERSION} | sh -s -- install --no-confirm
			fi
		}

		if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
			# shellcheck source=/dev/null
			. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
		fi

		info "'Nix' is installed! Here is what we have:"
		nix-shell -p nix-info --run "nix-info -m"
	}

	install_home_manager() {
		echo
		header "Installing Home Manager"
		if ! nix-channel --list | grep -q home-manager; then
			warn "Adding 'home-manager' Nix channel..."
			nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
		fi

		nix-channel --update
		info "Home Manager channel is installed. Here are available channels:"
		nix-channel --list
	}

	setup_home_manager() {
		echo
		header "Running Home Manager"
		command -v home-manager >/dev/null || {
			warn "'home-manager' is not installed. installing..."
			nix run home-manager/master -- init --switch
		}
		mkdir -p ~/.config

		if [ -e "$HOME/.config/home-manager" ]; then
			info "Backing up $HOME/.config/home-manager to $HOME/.config/home-manager-backup"
			mv --backup=numbered "$HOME/.config/home-manager" "$HOME/.config/home-manager-backup"
		fi

		# Setup default nix home-manager profile
		NIX_HOST=home
		HARDWARE=default
		ARCH=x86_64-linux

		OS_TYPE=$(uname -s)
		if [ "$OS_TYPE" = "Darwin" ]; then
			ARCH=x86_64-darwin
		fi

		cd ~/environment/nix
		home-manager switch --flake ".#$USER-$NIX_HOST-$HARDWARE-$ARCH"

		info "home-manger is configured! Here is what we have:"
		home-manager --version
	}

	install_homebrew() {
		echo
		header "Installing Homebrew"
		command -v brew >/dev/null || {
			warn "'Homebrew' is not installed. Installing..."
			NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		}
		info "'Homebrew' is installed! Here is what we have:"
		if command -v brew; then
			brew --version
		else
			error "Unable to find brew in path..."
		fi
	}

	clone_repository() {
		local repository="git@github.com:JateNensvold/environment.git"

		local clone_target="${HOME}/environment"
		header "Setting up the configuration from ${repository}..."

		# Reset environment repo if it already exists
		if [ -e "${clone_target}/" ]; then
			warn "Looks like '${clone_target}' exists and it is not what we want. Backing up as '${clone_target}.backup-before-clone'..."
			mv --backup=numbered "${clone_target}" "${clone_target}.backup-before-clone"
		fi
		warn "Cloning '${repository}' into '${clone_target}'..."
		git clone "${repository}" "${clone_target}"

		info "'${clone_target}' is sourced from github.com:'${repository}'."
		cd "${clone_target}"
		git remote -v
		cd - >/dev/null
	}

	ssh_support() {
		# Piped commands output status of first command, split across two lines to get grep status
		ssh_output=$(ssh -T -p 443 git@ssh.github.com 2>&1)
		echo "${ssh_output}" | grep -q success
		exit_code=$?
		if [[ $exit_code -eq 0 ]]; then
			# Supported
			return 0
		fi
		# Not Supported
		return 1
	}

	add_ssh_key() {
		host=$1
		port=$2

		if ! grep -F "$host" ~/.ssh/known_hosts >/dev/null; then
			if [[ -z $port ]]; then
				ssh-keyscan -t rsa -p "$port" "$host" >>~/.ssh/known_hosts
			else
				ssh-keyscan -t rsa "$host" >>~/.ssh/known_hosts
			fi
		fi
	}

	git_SSH_convert() {

		ssh_support
		exit_code=$?
		if [[ $exit_code -eq 0 ]]; then
			git remote set-url origin git@github.com:JateNensvold/environment.git
		fi
	}

	restart_ssh() {
		killall ssh-agent
		eval "$(ssh-agent)"
	}

	setup() {
		add_ssh_key "ssh.github.com" "443"
		add_ssh_key "github.com" "443"
		if ! ssh_support; then
			error "Users SSH key not found, add SSH key to resolve issue..."
			return 1
		fi

		sudo_prompt
		install_nix "$2"
		install_home_manager
		install_homebrew
		clone_repository
		setup_home_manager
		git_SSH_convert
	}

	if [ "$1" = "setup" ]; then
		setup "$@"
	fi
} # Prevent script running if partially downloaded
