#!/bin/bash

# Can be ran with bash or ZSH
# Exit on errors
set -e
# Instructions taken from https://nickjanetakis.com/blog/install-docker-in-wsl-2-without-docker-desktop

# Install Docker, you can ignore the warning from Docker about using WSL
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Add your user to the Docker group
sudo usermod -aG docker "$USER"

# Install Docker Compose v2
sudo apt-get update && sudo apt-get install docker-compose-plugin

# Sanity check that both tools were installed successfully
docker --version
docker compose version

# Using Ubuntu 22.04 or Debian 10 / 11? You need to do 1 extra step for iptables
# compatibility, you'll want to choose option (1) from the prompt to use iptables-legacy.

echo "Choose Option 1 on WSL"

sudo update-alternatives --config iptables

# Update socket permissions to run docker without sudo
sudo chmod 666 /var/run/docker.sock