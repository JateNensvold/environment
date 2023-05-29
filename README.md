### Setup

## Prerequisites

<!-- 1 FireFox using this [link](https://www.mozilla.org/en-US/firefox/new/)

1 WSL2 by following the instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install)

1 VSCode by following the instructions [here](https://code.visualstudio.com/download) -->

<!-- 1. Open VSCode and install the [WSL extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)

    - Open a WSL2 terminal in vscode by hitting the keys `"Ctrl" + "Shift" + "P"` or by opening `View -> Command Pallete` and running the command
        - `WSL: Connect to WSL` -->
- Create a new SSH key
    - Follow the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux#generating-a-new-ssh-key) for generating a key
    - Add the key to your SSH Keychain using the [instructions here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux#adding-your-ssh-key-to-the-ssh-agent)
    - Add the key to your [github account](https://github.com/settings/keys) using the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account)

## Setup Development Environment

1. Run the following commands to clone this repo
    ```zsh
    mkdir ~/projects && cd ~/projects && git clone git@github.com:JateNensvold/environment.git

    git submodule init
    git submodule update
    ```

1. Run the following script for setting up dotfiles
    ```zsh
    git clone git@github.com:JateNensvold/dotfiles.git
    ```

## VSCode Settings & Keybindings
1. VSCode Global Configuration

- Reopen Closed tab
    `Ctrl + Shift + W`
- Close Tab
    `Ctrl + W`
### VSCode Default Keybindings
https://github.com/codebling/vs-code-default-keybindings/tree/master

### VSCode Default Settings
These are the default settings filepaths on Linux, macOS, and Windows
```
Windows %APPDATA%\Code\User\settings.json
macOS $HOME/Library/Application\ Support/Code/User/settings.json
Linux $HOME/.config/Code/User/settings.json
```
### Todo

    - Wallpaper engine[Not supported without [SteamCMD](https://www.digitalcitizen.life/steam-cmd-windows/)]
    - VSCode
        - Extensions
    - powertoys
        - Settings[[Not Support currently]](https://github.com/microsoft/PowerToys/issues/4649)
            - Manual backup and restores of settings is available, latest settings should be stored in `environment/settings/powertoys/`
    - Ubuntu Environment Setup
        - Docker without Docker Desktop
        ```zsh
        ./scripts/wsl2-docker-install.sh
        ```
        - rust toolchain
        - Zsh

### Current Functionality
- Windows
    - Enable WSL2
    - Remove Windows Default Programs
    - Disable Windows Settings
        - StickyKeys
    - Update Windows(WIP)
    - Install Program list [[Full List Found Here]](scripts/windows/windows-tools.json)
        - FireFox
        - VSCode
        - Spotify
        - Discord
        - ...
    - Automatic update of setting/program configuration to defaults in this Repo
        - [PowerToys](settings/powertoys/settings.ptb)
        - VSCode
            - [Keybindings](settings/vscode/keybindings.json)
            - [Settings](settings/vscode/settings.json)
            - [Extensions](settings/vscode/global-extensions.json)
- WSL2
    - Program Configs
        - [Git](settings/dotfile_settings/.gitconfig)
        - [ZSH](settings/dotfile_settings/.zhrc)
    - VSCode
        - WSL and Windows Settings and Keybindings sync with same Global Settings
        - Extensions
    - Install Program List
        - ZSH
        - Brew
        - PowerLevel10k
        - Docker(No Docker Desktop)
        - ...

Install steps
1. Windows Install
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (iwr https://raw.githubusercontent.com/JateNensvold/environment/master/windows-install.ps1 -Headers @{"Cache-Control" = "no-cache" }).Content
```
