#Requires -Version 7.0
#Requires -RunAsAdministrator

# Module Imports #################################
$LIB_FOLDER_NAME = "lib"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path (get-item $PSScriptRoot).Parent $LIB_FOLDER_NAME
$FILE_COMMAND_MODULE = "File-Command.psm1"

Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $FILE_COMMAND_MODULE) -Force
###################################################

# Function to install VSCode Extension
function Install-Extension {
    param (
        [string]$vscodeVersion,
        [string]$extension
    )
    Invoke-Expression "$vscodeVersion --install-extension $extension"
}

$APPDATA_PATH = Get-ChildItem Env:APPDATA | Select-Object Value -ExpandProperty Value
$ENVIRONMENT_DIRECTORY = (get-item $PSScriptRoot).Parent.Parent.Parent.FullName

$VSCODE_FOLDER_PATH = Join-Path $APPDATA_PATH "Code" "User"
$VSCODE_INSIDER_FOLDER_PATH = Join-Path $APPDATA_PATH "Code - Insiders" "User"

$VSCODE_SETTINGS_TARGET_FILEPATH = Join-Path $VSCODE_FOLDER_PATH "settings.json"
$VSCODE_KEYBINDS_TARGET_FILEPATH = Join-Path $VSCODE_FOLDER_PATH "keybindings.json"
$VSCODE_INSIDER_SETTINGS_TARGET_FILEPATH = Join-Path $VSCODE_INSIDER_FOLDER_PATH "settings.json"
$VSCODE_INSIDER_KEYBINDS_TARGET_FILEPATH = Join-Path $VSCODE_INSIDER_FOLDER_PATH "keybindings.json"
$VSCODE_SETTINGS_BACKUP_FILEPATH = join-path $VSCODE_FOLDER_PATH "backup_settings.json"
$VSCODE_KEYBINDS_BACKUP_FILEPATH = join-path $VSCODE_FOLDER_PATH "backup_keybindings.json"

$VSCODE_SETTINGS_SOURCE_FOLDER = Join-Path $ENVIRONMENT_DIRECTORY "dotfiles" "vscode"
$VSCODE_SETTINGS_SOURCE_FILEPATH = Join-Path $VSCODE_SETTINGS_SOURCE_FOLDER "settings.json"
$VSCODE_KEYBINDS_SOURCE_FILEPATH = Join-Path $VSCODE_SETTINGS_SOURCE_FOLDER "keybindings.json"

# $VSCODE_SETTINGS_LOCAL_FOLDER = Join-Path $ENVIRONMENT_DIRECTORY ".vscode"
# $VSCODE_SETTINGS_LOCAL_FILEPATH = Join-Path $VSCODE_SETTINGS_LOCAL_FOLDER "settings.json"
# $VSCODE_KEYBINDS_LOCAL_FILEPATH = Join-Path $VSCODE_SETTINGS_LOCAL_FOLDER "keybindings.json"
# $VSCODE_SETTINGS_LOCALBACKUP_FILEPATH = join-path $VSCODE_SETTINGS_LOCAL_FOLDER `
#     "backup_settings.json"
# $VSCODE_KEYBINDS_LOCALBACKUP_FILEPATH = join-path $VSCODE_SETTINGS_LOCAL_FOLDER `
#     "backup_keybindings.json"

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting VSCode Settings" -ForegroundColor Green
Write-Host "Moving Old VSCode settings from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_BACKUP_FILEPATH -ForegroundColor Cyan

Write-Host "Moving Old VSCode keybinds from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_BACKUP_FILEPATH -ForegroundColor Cyan

# Export existing VSCode Settings and Keybinds to backup to ensure a temporary backup
Export-File $VSCODE_SETTINGS_TARGET_FILEPATH $VSCODE_SETTINGS_BACKUP_FILEPATH -Force
Export-File $VSCODE_KEYBINDS_TARGET_FILEPATH $VSCODE_KEYBINDS_BACKUP_FILEPATH -Force

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Symlinking new settings for VSCode, from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan

Write-Host "Symlinking new keybindings from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

# Link Settings and Keybinds from environment project to new VSCode user location
Initialize-link $VSCODE_SETTINGS_TARGET_FILEPATH $VSCODE_SETTINGS_SOURCE_FILEPATH
Initialize-link $VSCODE_KEYBINDS_TARGET_FILEPATH $VSCODE_KEYBINDS_SOURCE_FILEPATH

Write-Host "Symlinking new settings for VSCode Insiders, from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_INSIDER_SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan

Write-Host "Symlinking new keybindings from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_INSIDER_KEYBINDS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

# Link Settings and Keybinds from environment project to new VSCode Insider user location
Initialize-link $VSCODE_INSIDER_SETTINGS_TARGET_FILEPATH $VSCODE_SETTINGS_SOURCE_FILEPATH
Initialize-link $VSCODE_INSIDER_KEYBINDS_TARGET_FILEPATH $VSCODE_KEYBINDS_SOURCE_FILEPATH

# Install VSCode Windows extensions
$GLOBAL_EXTENSIONS_JSON_PATH = Join-Path $VSCODE_SETTINGS_SOURCE_FOLDER "global-extensions.json"
$JSON_OBJECT = Get-Content -Raw -Path $GLOBAL_EXTENSIONS_JSON_PATH | ConvertFrom-Json
$EXTENSION_GROUPS = $JSON_OBJECT.extensions

$BASE_EXTENSIONS = $EXTENSION_GROUPS.base
$TERMINAL_EXTENSIONS = $EXTENSION_GROUPS.terminal
$WINDOWS_EXTENSIONS = $EXTENSION_GROUPS.windows

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Installing VSCode Extensions" -ForegroundColor Green

foreach ($extension in $BASE_EXTENSIONS) {
    Install-Extension code $extension
    Install-Extension code-insiders $extension
}

foreach ($extension in $TERMINAL_EXTENSIONS) {
    Install-Extension code $extension
    Install-Extension code-insiders $extension
}

foreach ($extension in $WINDOWS_EXTENSIONS) {
    Install-Extension code $extension
    Install-Extension code-insiders $extension
}

Write-Host "------------------------------------" -ForegroundColor Yellow
