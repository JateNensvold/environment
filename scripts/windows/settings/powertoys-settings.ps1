
#Requires -Version 7.0
#Requires -RunAsAdministrator

$USER_DIR = Resolve-Path ~
$ENVIRONMENT_DIRECTORY = (get-item $PSScriptRoot).Parent.Parent.Parent.FullName

$SETTINGS_FILEPATH = Join-Path $ENVIRONMENT_DIRECTORY "settings" "powertoys" "settings.ptb"
$POWERTOYS_TARGET_FILEPATH = Join-Path $USER_DIR "Documents" "PowerToys" "Backup"

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting up Powertoy Settings for manual loading" -ForegroundColor Green
Write-Host "Symlinking new settings from " -NoNewline -ForegroundColor Green
Write-Host $SETTINGS_FILEPATH -NoNewline -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $POWERTOYS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

New-Item -Path $SETTINGS_TARGET_FILEPATH -ItemType SymbolicLink -Value $SETTINGS_FILEPATH

