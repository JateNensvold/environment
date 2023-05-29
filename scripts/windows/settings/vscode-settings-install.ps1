#Requires -Version 7.0
#Requires -RunAsAdministrator

$APPDATA_PATH = Get-ChildItem Env:APPDATA | Select-Object Value -ExpandProperty Value
$ENVIRONMENT_DIRECTORY = (get-item $PSScriptRoot).Parent.Parent.Parent.FullName

$VSCODE_FOLDER_PATH = Join-Path $APPDATA_PATH "Code" "User"
$VSCODE_SETTINGS_TARGET_FILEPATH = Join-Path $VSCODE_FOLDER_PATH "settings.json"
$VSCODE_KEYBINDS_TARGET_FILEPATH = Join-Path $VSCODE_FOLDER_PATH "keybindings.json"
$VSCODE_SETTINGS_BACKUP_FILEPATH = join-path $VSCODE_FOLDER_PATH "backup_settings.json"
$VSCODE_KEYBINDS_BACKUP_FILEPATH = join-path $VSCODE_FOLDER_PATH "backup_keybindings.json"

$VSCODE_SETTINGS_SOURCE_FOLDER = Join-Path $ENVIRONMENT_DIRECTORY "settings" "vscode"
$VSCODE_SETTINGS_SOURCE_FILEPATH = Join-Path $VSCODE_SETTINGS_SOURCE_FOLDER "settings.json"
$VSCODE_KEYBINDS_SOURCE_FILEPATH = Join-Path $VSCODE_SETTINGS_SOURCE_FOLDER "keybindings.json"




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

Write-Host "Symlinking new settings from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan

Write-Host "Symlinking new keybindings from " -NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_SOURCE_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $VSCODE_KEYBINDS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow


# mv $VSCODE_SETTINGS_FILEPATH (join-path $VSCODE_FOLDER_PATH "backup_settings.json")
# mv $VSCODE_SETTINGS_FILEPATH (join-path $VSCODE_FOLDER_PATH "backup_keybindings.json")

# New-Item -Path $VSCODE_SETTINGS_TARGET_FILEPATH -ItemType SymbolicLink -Value $VSCODE_SETTINGS_SOURCE_FILEPATH
# New-Item -Path $VSCODE_KEYBINDS_TARGET_FILEPATH -ItemType SymbolicLink -Value $VSCODE_KEYBINDS_SOURCE_FILEPATH