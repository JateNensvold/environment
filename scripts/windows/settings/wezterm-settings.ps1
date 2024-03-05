#Requires -Version 7.0
#Requires -RunAsAdministrator

# Module Imports #################################
$LIB_FOLDER_NAME = "lib"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path (get-item $PSScriptRoot).Parent $LIB_FOLDER_NAME
$FILE_COMMAND_MODULE = "File-Command.psm1"

Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $FILE_COMMAND_MODULE) -Force
###################################################

$USER_DIR = Resolve-Path ~
$ENVIRONMENT_DIRECTORY = (get-item $PSScriptRoot).Parent.Parent.Parent.FullName

$OLD_SETTINGS_FILEPATH = Join-Path $USER_DIR ".wezterm.lua.old"
$SETTINGS_FILEPATH = Join-Path $ENVIRONMENT_DIRECTORY "settings" "wezterm" ".wezterm.lua"
$SETTINGS_TARGET_FILEPATH = Join-Path $USER_DIR ".wezterm.lua"

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting Wezterm Settings" -ForegroundColor Green
Write-Host "Moving Old Wezterm setting from " -NoNewline -ForegroundColor Green
Write-Host $SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $OLD_SETTINGS_FILEPATH -ForegroundColor Cyan

Write-Host "Symlinking new settings from " -NoNewline -ForegroundColor Green
Write-Host $SETTINGS_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $SETTINGS_TARGET_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

Export-File $SETTINGS_TARGET_FILEPATH $OLD_SETTINGS_FILEPATH -Force
Initialize-link $SETTINGS_TARGET_FILEPATH $SETTINGS_FILEPATH
