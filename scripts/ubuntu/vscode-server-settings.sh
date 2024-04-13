#!/bin/bash

script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
repo_root="$script_dir/../.."

ln "${repo_root}/dotfiles/vscode/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"
