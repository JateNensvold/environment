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
  while true ; do sudo -n true ; sleep 60 ; kill -0 "$$" || exit ; done 2>/dev/null &
}

install_nix() {
  echo
  header "Installing Nix"
  command -v nix >/dev/null || {
    warn "'Nix' is not installed. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  }
  info "'Nix' is installed! Here is what we have:"
  nix-shell -p nix-info --run "nix-info -m"
}

install_home_manager() {
  echo
  header "Installing Home Manager"
  if [[ ! $( nix-channel --list | grep -q home-manager ) ]]; then
    warn "Adding 'home-manager' Nix channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
  fi
  info "Home Manager channel is installed. Here are available channels:"
  nix-channel --list
}

setup_home_manager() {
  echo
  header "Running Home Manager"
  command -v home-manager >/dev/null || {
    warn "'home-manager' is not installed. installing..."
    nix-shell '<home-manager>' -A install
  }
  mkdir -p ~/.config

  if [ ! -e "$HOME/.config/home-manager" ];
  then
    mv --backup=numbered "$HOME/.config/home-manager" "$HOME/.config/home-manager-backup"
  fi
  ln -s ~/environment/settings/nix/ ~/.config/home-manager

  home-manager switch

  info "home-manger is configured! Here is what we have:"
  home-manager --version
}

install_homebrew() {
  echo
  header "Installing Homebrew"
  command -v brew >/dev/null || {
    warn "'Homebrew' is not installed. Installing..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }
  info "'Homebrew' is installed! Here is what we have:"
  if command -v brew
  then
    brew --version
  else
    error "Unable to find brew in path..."
  fi
}

clone_repository() {
  echo
  local repository="git@github.com:JateNensvold/environment.git"
  local clone_target="${HOME}/environment"
  header "Setting up the configuration from github.com:${repository}..."

  if [[ ! $( cat "${clone_target}/.git/config" | grep "github.com" | grep "${repository}" ) ]]; then
    if [ -d "${clone_target}" ]; then
      warn "Looks like '${clone_target}' exists and it is not what we want. Backing up as '${clone_target}.backup-before-clone'..."
      mv  --backup=numbered "${clone_target}" "${clone_target}.backup-before-clone"
    fi
    warn "Cloning '${repository}' into '${clone_target}'..."
    git clone "${repository}" "${clone_target}"
  fi

  info "'${clone_target}' is sourced from github.com:'${repository}'."
  cd "${clone_target}"
  git remote -v
  cd - >/dev/null
}

sudo_prompt
install_nix
install_home_manager
install_homebrew
clone_repository
setup_home_manager

} # Prevent script running if partially downloaded