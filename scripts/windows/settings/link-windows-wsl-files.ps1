# Requires -Version 7.0

$WSL_HOME_DIRECTORY = (wsl echo `$HOME)
$WSL_ENVIRONMENT_DIRECTORY = (Join-Path $WSL_HOME_DIRECTORY "environment").replace("\", "/")
$WSL_ENVIRONMENT_PATH_AS_WINDOWS_PATH = (wsl wslpath -w $WSL_ENVIRONMENT_DIRECTORY)

$WINDOWS_USER_PATH = (get-item (Resolve-Path ~)).FullName
$WINDOWS_ENVIRONMENT_PATH = (Join-Path $WINDOWS_USER_PATH "environment")
$WINDOWS_ENVIRONMENT_PATH_ESCAPED = $WINDOWS_ENVIRONMENT_PATH.replace("\", "\\")
$WINDOWS_ENVIRONMENT_AS_WSL_PATH = (wsl wslpath $WINDOWS_ENVIRONMENT_PATH_ESCAPED)

$WSL_ENVIRONMENT_DIRECTORY_BACKUP = (Join-Path $WSL_HOME_DIRECTORY "backup_environment").replace("\", "/")

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Linking Environment Directory from WSL" -ForegroundColor Green
Write-Host "Symlinking Environment to Windows: " -NoNewline -ForegroundColor Green
Write-Host $WSL_ENVIRONMENT_DIRECTORY  -ForegroundColor Cyan
Write-Host " to: "-NoNewline -ForegroundColor Green
Write-Host $WINDOWS_ENVIRONMENT_PATH_ESCAPED -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

# Backup any WSL environment directory that currently exists
wsl mv $WSL_ENVIRONMENT_DIRECTORY $WSL_ENVIRONMENT_DIRECTORY_BACKUP
# Move the Windows environment directory into wsl
wsl mv $WINDOWS_ENVIRONMENT_AS_WSL_PATH $WSL_ENVIRONMENT_DIRECTORY

# Linking from WSL is disabled, but from within Ubuntu it is not
# Export-File $WSL_ENVIRONMENT_PATH $ENVIRONMENT_DIRECTORY_BACKUP -Force

Initialize-link $WINDOWS_ENVIRONMENT_PATH $WSL_ENVIRONMENT_PATH_AS_WINDOWS_PATH

# Change from linking directory to link every file in directory to get around wslpath resolving
#   symlinks for devcontainers https://github.com/microsoft/vscode-remote-release/issues/6605
#
#   Update: This still causes issues with docker, switching back to linking the folder, but instead
#   linking from WSL to windows

# Link windows downloads directory into WSL as well
$WINDOWS_DOWNLOAD_PATH = (get-item (New-Object -ComObject `
            Shell.Application).NameSpace('shell:Downloads').Self.Path).FullName.Replace("\", "\\")
$WSL_DOWNLOAD_PATH = (wsl wslpath $WINDOWS_DOWNLOAD_PATH)

wsl ln -s $WSL_DOWNLOAD_PATH "~/downloads"

# Link windows Documents directory into WSL as well
$WINDOWS_DOCUMENTS_PATH = (get-item (New-Object -ComObject `
            Shell.Application).NameSpace('shell:Documents').Self.Path).FullName.Replace("\", "\\")
$WSL_DOCUMENTS_PATH = (wsl wslpath $WINDOWS_DOWNLOAD_PATH)

wsl ln -s $WSL_DOCUMENTS_PATH "~/documents"

# Setup WSL environment
wsl bash -i <(curl -fsSL https://raw.githubusercontent.com/JateNensvold/environment/master/scripts/ubuntu/install.sh)
