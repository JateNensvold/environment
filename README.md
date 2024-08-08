# Environment

This is the repo that contains my environment setup scripts and dotfiles.
[There are many others but this one is mine](https://github.com/andremedeiros/dotfiles/tree/20779ba9cb5c88a21e98a7a49ac9cb0d3e5868c6)

## Install

Follow the below instructions on your desired operating system to run the environment
setup scripts

### Dependencies

Prerequisites

1. Git
1. bash
1. curl

### Linux/MacOS Installation

Copy and run the following command to automate environment setup(Tested on
ubuntu 22.04(WSL), AL2, MacOS 14.5(M2))

```bash
bash -i <(curl -fsSL https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh) setup
```

**Note**
On some platforms the nixbld GID are taken already, in that case add the NIXBLD
start ID to the setup command

```bash
# setup nixbld starting at ID 20000400
bash -i <(curl -fsSL https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh) setup 20000400

```

### Windows Installation

Prerequisites

1. Windows 11
1. Powershell 5+

Copy and run the following command in Powershell 5 to setup windows 11

```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (iwr https://raw.githubusercontent.com/JateNensvold/environment/master/windows-install.ps1 -Headers @{"Cache-Control" = "no-cache" }).Content
```

## Configuration

### Linux configuration

Modify the below values to the desired Host configuration. See [flake.nix](
./flake.nix) for supported values

```zsh
# Example nix home-manager setup
export NIX_HOST=home
export HARDWARE=default
export ARCH=x86_64-linux
```

Rerun the home-manager switch command from `~/environment/` to change to the
desire home-manager configuration.

```zsh
reload
```

or

```zsh
cd ~/environment/
home-manager switch --flake ~/environment/.#$USER-$NIX_HOST-$HARDWARE-$ARCH -b hm-backup
```

### MacOS configuration

Change ARCH to darwin supported architecture and follow the same steps as in[
Linux configuration](#linux-configuration)

```zsh
# Example nix darwin setup
export NIX_HOST=home
export HARDWARE=default
export ARCH=x86_64-darwin
# export ARCH=aarch64-darwin
```

```zsh
reload
```

or

```zsh
cd ~/environment/
darwin-rebuild switch --flake ~/environment/.#$USER-$NIX_HOST-$HARDWARE-$ARCH -b hm-backup
```

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
- WSL2/Linux/MacOS
  - Nix
  - Programs
  - Program Configs

## Settings & Keybindings

- Media Keys for Mode 65
  - Resume/Pause Music `fn + \`
  - Previous song `fn [`
  - Next song `fn ]`
  - Volume up `fn PgUp`
  - Volume down `fn PgDn`

### Windows PowerToys

- Run program
    `Win + Space`
- Focus Cursor
    `L-Ctrl` x2

### Wezterm

- New Terminal
    `Ctrl + Shift + T`
- Cycle Terminal
    `Ctrl + Tab`

## Todo

- Windows
  - Wallpaper engine[Not supported without [SteamCMD](https://www.digitalcitizen.life/steam-cmd-windows/)]
  - Pin programs to windows Taskbar
  - powertoys
    - Settings[[Not Support currently]](https://github.com/microsoft/PowerToys/issues/4649)
      - Manual backup and restores of settings is available, latest settings should be
            stored in `environment/settings/powertoys/`, currently settings will be linked to the
            powertoys install directory but the user has to manually load them
