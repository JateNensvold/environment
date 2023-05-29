#Requires -Version 7.0
#Requires -RunAsAdministrator

# Module Imports #################################
$LIB_FOLDER_NAME = "lib"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path (get-item $PSScriptRoot).Parent $LIB_FOLDER_NAME
$FILE_COMMAND_MODULE = "File-Command.psm1"

Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $FILE_COMMAND_MODULE) -Force
###################################################


$APPDATA_PATH = Get-ChildItem Env:APPDATA | Select-Object Value -ExpandProperty Value
$ROAMING_PATH = $APPDATA_PATH
$ENVIRONMENT_DIRECTORY = (get-item $PSScriptRoot).Parent.Parent.Parent.FullName

$OLD_SETTINGS_FILEPATH = Join-Path $ROAMING_PATH "old_settings.xml"
$SETTINGS_FILEPATH = Join-Path $ENVIRONMENT_DIRECTORY "settings" "conemu" "settings.xml"
$SETTINGS_TARGET_FILEPATH = Join-Path $ROAMING_PATH "settings.xml"

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting ConEmu Settings" -ForegroundColor Green
Write-Host "Moving Old ConEmu setting from " -NoNewline -ForegroundColor Green
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
