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

$POWERTOY_ENVIRONMENT_FOLDERPATH= Join-Path $ENVIRONMENT_DIRECTORY "settings" "powertoys" "backup"
$POWERTOYS_DEFAULT_FOLDERPATH= Join-Path $USER_DIR "Documents" "PowerToys" "Backup"
$POWERTOYS_OLD_FOLDERPATH= Join-Path $USER_DIR "Documents" "PowerToys" "Backup-old"


Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting up Powertoy Settings for manual loading" -ForegroundColor Green
Write-Host "Symlinking new settings from " -NoNewline -ForegroundColor Green
Write-Host $POWERTOY_ENVIRONMENT_FOLDERPATH -ForegroundColor Cyan
Write-Host " to "-NoNewline -ForegroundColor Green
Write-Host $POWERTOYS_DEFAULT_FOLDERPATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

Export-File $POWERTOYS_DEFAULT_FOLDERPATH $POWERTOYS_OLD_FOLDERPATH -Force
Initialize-link $POWERTOYS_DEFAULT_FOLDERPATH $POWERTOY_ENVIRONMENT_FOLDERPATH
