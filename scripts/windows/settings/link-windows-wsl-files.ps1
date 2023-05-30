#Requires -Version 7.0

$WSL_HOME_DIRECTORY = (wsl echo `$HOME)
$WSL_ENVIRONMENT_DIRECTORY = (Join-Path $WSL_HOME_DIRECTORY "environment").replace("\", "/")
$WINDOWS_ENVIRONMENT_ESCAPED_PATH = (Join-Path (get-item (Resolve-Path ~)).FullName "environment").replace("\", "\\")
# $WINDOWS_ENVIRONMENT_AS_WSL_PATH = (wsl wslpath $WINDOWS_ENVIRONMENT_ESCAPED_PATH)
$WSL_ENVIRONMENT_DIRECTORY_BACKUP = (Join-Path $WSL_HOME_DIRECTORY "backup_environment").replace("\", "/")

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Linking Environment Directory to WSL" -ForegroundColor Green
Write-Host "Symlinking Environment from " -NoNewline -ForegroundColor Green
Write-Host $ENVIRONMENT_DIRECTORY -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $WSL_ENVIRONMENT_TARGET_PATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

# Export-File $WSL_ENVIRONMENT_PATH $ENVIRONMENT_DIRECTORY_BACKUP -Force
wsl mv $WSL_ENVIRONMENT_DIRECTORY $WSL_ENVIRONMENT_DIRECTORY_BACKUP
# Linking from windows is disabled, but from within wsl it is not
# Initialize-link $WSL_ENVIRONMENT_PATH $ENVIRONMENT_DIRECTORY


# Change from linking directory to link every file in directory to get around wslpath resolving
#   symlinks for devcontainers https://github.com/microsoft/vscode-remote-release/issues/6605
# wsl ln $WINDOWS_ENVIRONMENT_AS_WSL_PATH $WSL_ENVIRONMENT_DIRECTORY

# Make a new WSL directory
wsl mkdir -p $WSL_ENVIRONMENT_DIRECTORY

# Link all children into Environment directory
$WINDOWS_FILES = Get-ChildItem $WINDOWS_ENVIRONMENT_ESCAPED_PATH

foreach ($window_file in $WINDOWS_FILES) {
    $filepath = $window_file.FullName.replace("\", "\\")
    $windows_filepath_as_wsl = wsl wslpath $filepath
    # wsl ln -s $windows_filepath_as_wsl (get-item (Join-Path $WSL_ENVIRONMENT_DIRECTORY `
    #             $window_file.Name)).FullName.replace("\", "/")
    wsl ln -s $windows_filepath_as_wsl (Join-Path $WSL_ENVIRONMENT_DIRECTORY `
            $window_file.Name).replace("\", "/")
}

# Link windows downloads directory into WSL as well
$WINDOWS_DOWNLOAD_PATH = (get-item (New-Object -ComObject `
            Shell.Application).NameSpace('shell:Downloads').Self.Path).FullName.Replace("\", "\\")
$WSL_DOWNLOAD_PATH = (wsl wslpath $WINDOWS_DOWNLOAD_PATH)

wsl ln -s $WSL_DOWNLOAD_PATH "~/downloads"