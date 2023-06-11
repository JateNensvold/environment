## Prerequisites



## Install

### Windows
Prerequisites
1. Powershell 5

1. Windows Install
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (iwr https://raw.githubusercontent.com/JateNensvold/environment/master/windows-install.ps1 -Headers @{"Cache-Control" = "no-cache" }).Content
```

### Ubuntu/WSL

Prerequisites - Note, most of these prerequisites come preinstalled or will be added by the
    windows setup script
1. Git
2. vscode
3. bash
4. Create a new SSH key
    - Follow the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux#generating-a-new-ssh-key) for generating a key
    - Add the key to your SSH Keychain using the [instructions here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux#adding-your-ssh-key-to-the-ssh-agent)
    - Add the key to your [github account](https://github.com/settings/keys) using the instructions [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account)

#### WSL setup

Copy and run the following command to automate the setup of an WSL environment
```
https://raw.githubusercontent.com/JateNensvold/environment/master/windows-install.ps1
```

#### Ubuntu Setup

Copy and run the following command to automate the setup of an ubuntu environment
```bash
https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/linux-setup
```

#### Mac Setup
WIP, check todo section

## Current Functionality
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

## Settings & Keybindings

- Media Keys
    - Resume/Pause Music `fn + \`
    - Previous song `fn [`
    - Next song `fn ]`
    - Volume up `fn PgUp`
    - Volume down `fn PgDn`

### VScode
#### Custom VSCode Keybindings
- Reopen Closed tab
    `Ctrl + Shift + W`
- Close Tab
    `Ctrl + W`
- New Terminal
    `Ctrl + Shift + T`
- Cycle Terminal
    `Ctrl + Shift <Up/Down>`
- Open/Close Terminal
    `Ctrl + Shift + . `
- Focus Terminal
    `Ctrl + j`
- Focus Editor
    `Ctrl + k`
#### VSCode Default Keybindings
https://github.com/codebling/vs-code-default-keybindings/tree/master

#### VSCode Default Settings
These are the default settings filepaths on Linux, macOS, and Windows
```
Windows %APPDATA%\Code\User\settings.json
macOS $HOME/Library/Application\ Support/Code/User/settings.json
Linux $HOME/.config/Code/User/settings.json
```

### Windows PowerToys

- Run program
    `Win + Space`
- Focus Cursor
    `L-Ctrl` x2

### Conemu
- Focus window
    `L-Ctrl + 1`
- Open Settings
    `Win + Alt + P`
- New Terminal
    `Ctrl + T`
- Cycle Terminal
    `Ctrl + Tab`

## Setup Development Environment

1. Run the following commands to clone this repo
    ```bash
    git clone git@github.com:JateNensvold/environment.git

    cd environment
    git submodule init
    git submodule update
    ```

To test new settings in the devcontainer edit the settings config at
environment/.vscode/settings.json

## Todo
- Remove dotfiles submodule
    - Dotfiles repo may be out of place when bash files are more portable
- Mac setup Script
- Windows
    - Wallpaper engine[Not supported without [SteamCMD](https://www.digitalcitizen.life/steam-cmd-windows/)]
    - Pin programs to windows Taskbar
    - powertoys
        - Settings[[Not Support currently]](https://github.com/microsoft/PowerToys/issues/4649)
            - Manual backup and restores of settings is available, latest settings should be
            stored in `environment/settings/powertoys/`, currently settings will be linked to the
            powertoys install directory but the user has to manually load them
- Linux
    - Install script for VSCode for non WSL environments
    - rust toolchain?
    - Python?
