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
			if [[ $1 ]]; then

				NIX_INSTALL_VERSION=$1
			else
				NIX_INSTALL_VERSION="v0.11.0"
			fi
			NIX_BUILD_GROUP_ID=$2
			if [[ $NIX_BUILD_GROUP_ID ]]; then
				curl --proto '=https' --tlsv1.2 -sSf -L "https://install.determinate.systems/nix/tag/${NIX_INSTALL_VERSION}" | sh -s -- install --no-confirm --nix-build-group-id "$NIX_BUILD_GROUP_ID"
			else
				curl --proto '=https' --tlsv1.2 -sSf -L "https://install.determinate.systems/nix/tag/${NIX_INSTALL_VERSION}" | sh -s -- install --no-confirm
			fi
		}

		if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
			# shellcheck source=/dev/null
			. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
		fi

		info "'Nix' is installed! Here is what we have:"
		nix-shell -p nix-info --run "nix-info -m"
	}

	install_home_manager_channel() {
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
		# Setup default nix home-manager profile
		NIX_HOST=home
		HARDWARE=default
		ARCH=x86_64-linux

		OS_TYPE=$(uname -s)
		ARCH_TYPE=$(uname -m)

		echo
		header "Installing Home Manager"

		if [ "$OS_TYPE" = "Darwin" ]; then
			echo
			header "Skiping Home Manager install on darwin"

			ARCH=x86_64-darwin
			if [ "$ARCH_TYPE" = "arm64" ]; then
				ARCH=aarch64-darwin
			fi
		else

			command -v home-manager >/dev/null || {
				warn "'home-manager' is not installed. installing..."
				nix run home-manager/master -- init --switch
			}
			mkdir -p ~/.config

			if [ -e "$HOME/.config/home-manager" ]; then
				info "Backing up $HOME/.config/home-manager to $HOME/.config/home-manager-backup"
				backup_destination="$HOME/.config/home-manager-backup"

				rm -rf "$backup_destination" && mv "$HOME/.config/home-manager" "$backup_destination"
			fi
		fi

		# use a bash array for program arguments so they are split when passing to program
		homeManagerConfigurationCommandSuffix=(switch --flake ".#$USER-$NIX_HOST-$HARDWARE-$ARCH")

		cd ~/environment/
		if [ "$OS_TYPE" = "Darwin" ]; then
			nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- "${homeManagerConfigurationCommandSuffix[@]}"

			info "darwin: home-manager is configured! Here is what we have:"
			darwin-version
		else
			home-manager "${homeManagerConfigurationCommandSuffix[@]}" "-b hm-backup"

			info "home-manager is configured! Here is what we have:"
			home-manager --version
		fi
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
			backup_destination="${clone_target}.backup-before-clone"
			warn "Looks like '${clone_target}' exists and it is not what we want. Backing up as '${backup_destination}'..."
			rm -rf "$backup_destination" && mv "${clone_target}" "${backup_destination}"
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
		ssh_code=$?

		if [[ $ssh_code -eq 0 ]]; then
			# Supported
			return 0
		fi
		# Not Supported
		return 1
	}

	add_ssh_key() {
		host=$1
		port=$2

		mkdir -p ~/.ssh

		if [ ! -e ~/.ssh/known_hosts ]; then
			touch ~/.ssh/known_hosts
		fi

		if ! grep -F "$host" ~/.ssh/known_hosts >/dev/null; then
			# check if $port exists
			if [[ -n $port ]]; then
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
		# add github.com before other github subdomains so grep does not show it as detected
		add_ssh_key "github.com"
		add_ssh_key "ssh.github.com" "443"
		if ! ssh_support; then
			error "Users SSH key not found, add SSH key to  ~/.ssh to continue..."
			return 1
		fi

		sudo_prompt
		# Argument 2 is an optional determinate nix versions to install, argument 3 is an optional NIX_BUILD_GROUP_ID range,
		install_nix "$2" "$3"
		install_home_manager_channel
		# install_homebrew
		clone_repository
		setup_home_manager
		git_SSH_convert
	}
	# set -o xtrace

	if [ "$1" = "setup" ]; then
		setup "$@"
	else
		# allow functions to be invoked by calling the script with arguments
		set +eo pipefail
		"$@"
	fi
} # Prevent script running if partially downloaded
