# Overview

This Folder contains a multitude of scripts that can be used to install various linux and
windows applications and tools.

To initiate the installation process on windows run the following command

## Setup

### Windows

```powershell
Resolve-Path ~ | cd; Invoke-WebRequest <https://github.com/JateNensvold/environment/archive/master.zip>
```

### Linux

```bash
bash -i <(curl -fsSL https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh
```
