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

$SETTINGS_FILEPATH = Join-Path $ENVIRONMENT_DIRECTORY "settings" "powertoys" "settings.ptb"
$POWERTOYS_FILEPATH = Join-Path $USER_DIR "Documents" "PowerToys" "Backup" "settings.ptb"
$POWERTOYS_OLD_FILEPATH = Join-Path $USER_DIR "Documents" "PowerToys" "Backup"  "old_settings.ptb"


Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting up Powertoy Settings for manual loading" -ForegroundColor Green
Write-Host "Symlinking new settings from " -NoNewline -ForegroundColor Green
Write-Host $SETTINGS_FILEPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $POWERTOYS_FILEPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

Export-File $POWERTOYS_FILEPATH $POWERTOYS_OLD_FILEPATH -Force
Initialize-link $POWERTOYS_FILEPATH $SETTINGS_FILEPATH