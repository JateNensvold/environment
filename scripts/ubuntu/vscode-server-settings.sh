#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln "$SCRIPT_DIR/../../nix/dotfiles/vscode/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"