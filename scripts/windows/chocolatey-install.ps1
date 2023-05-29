#Requires -Version 5.0
#Requires -RunAsAdministrator

$LIB_FOLDER_NAME = "lib"
$CONFIRM_COMMAND_FILE = "Confirm-Command.psm1"
Import-Module (Join-Path $PSScriptRoot (Join-Path $LIB_FOLDER_NAME $CONFIRM_COMMAND_FILE))

if (Confirm-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
