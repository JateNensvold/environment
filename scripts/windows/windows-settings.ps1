#Requires -Version 7.0
#Requires -RunAsAdministrator

# Module Imports #################################
$LIB_FOLDER_NAME = "lib"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path $PSScriptRoot $LIB_FOLDER_NAME
$FILE_COMMAND_MODULE = "File-Command.psm1"

Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $FILE_COMMAND_MODULE) -Force
###################################################

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting up windows settings" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Yellow

$WINDOWS_SETTINGS_PATH = Join-Path windows settings

Invoke-File $WINDOWS_SETTINGS_PATH "stickykeys-disable.ps1"
Invoke-File $WINDOWS_SETTINGS_PATH "conemu-settings.ps1"
Invoke-File $WINDOWS_SETTINGS_PATH "powertoys-settings.ps1"
Invoke-File $WINDOWS_SETTINGS_PATH "vscode-settings-install.ps1"
Invoke-File $WINDOWS_SETTINGS_PATH "firefox-browser-default.ps1"
