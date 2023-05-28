# Elevate powershell to Administartor if it is not already
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
# Set ExecutionPolicy to run "untrusted" scripts during setup
Set-ExecutionPolicy Bypass -Scope Process -Force;

enum ScriptDirectories{
    Windows
    Ubuntu
}

function Invoke-File {
    param (
        [ScriptDirectories]$dirName,
        [string]$fileName
    )


    $SCRIPT_RELATIVE_PATH = Join-Path ($dirName) $fileName
    $SCRIPT_ABSOULTE_PATH = Join-Path $PSScriptRoot $SCRIPT_RELATIVE_PATH
    Write-Host "Running script: " -NoNewline -ForegroundColor Green
    Write-Host $SCRIPT_ABSOULTE_PATH -ForegroundColor Yellow
    # Write-Host "..." -ForegroundColor Yellow
    # & $SCRIPT_ABSOULTE_PATH
}

Invoke-File Windows "chocolatey-install.ps1"