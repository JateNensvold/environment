#!/bin/bash

# Exit on errors
set -e

script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
repo_root="$script_dir/../.."

VSCODE_EXTENSIONS_JSON_PATH="$repo_root/dotfiles/vscode/global-extensions.json"

BASE_EXTENSIONS_STRING=$(jq -r '.extensions.base | @sh' "$VSCODE_EXTENSIONS_JSON_PATH" | tr -d \')
TERMINAL_EXTENSIONS_STRING=$(jq -r '.extensions.terminal | @sh' "$VSCODE_EXTENSIONS_JSON_PATH" | tr -d \')
WSL_EXTENSIONS_STRING=$(jq -r '.extensions.wsl | @sh' "$VSCODE_EXTENSIONS_JSON_PATH" | tr -d \')

read -ra BASE_EXTENSIONS_ARR <<<"$BASE_EXTENSIONS_STRING"
read -ra TERMINAL_EXTENSIONS_ARR <<<"$TERMINAL_EXTENSIONS_STRING"
read -ra WSL_EXTENSIONS_ARR <<<"$WSL_EXTENSIONS_STRING"

for extension in "${BASE_EXTENSIONS_ARR[@]}"; do
	code --install-extension "$extension"
done

for extension in "${TERMINAL_EXTENSIONS_ARR[@]}"; do
	code --install-extension "$extension"
done

for extension in "${WSL_EXTENSIONS_ARR[@]}"; do
	code --install-extension "$extension"
done
