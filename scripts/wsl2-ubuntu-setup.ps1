#Requires -Version 5.0

$WSL_HOME_DIRECTORY = (wsl echo `$HOME)
$WSL_ENVIRONMENT_DIRECTORY = (Join-Path $WSL_HOME_DIRECTORY "environment").replace("\", "/")

wsl --shell-type login "$WSL_ENVIRONMENT_DIRECTORY/scripts/wsl2-ubuntu-setup"