function Show-Elevate($commandPath, $PS_VERSION) {
    Write-Host "------------------------------------" -ForegroundColor Yellow
    Write-Host "Elevating Permissions for " -NoNewline -ForegroundColor Green
    Write-Host "'$commandPath'" -NoNewline -ForegroundColor Cyan
    Write-Host " on Powershell Version: " -NoNewline -ForegroundColor Green
    Write-Host "'$PS_VERSION'" -ForegroundColor Cyan
    Write-Host "------------------------------------" -ForegroundColor Yellow
    Write-Host "A new prompt will open now... "-ForegroundColor Yellow
}

function Invoke-Administrator($commandPath) {
    $PS_VERSION = $PSVersionTable.PSVersion.Major
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Show-Elevate $commandPath $PS_VERSION
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
        exit
    }
}

function Invoke-Administrator7($commandPath) {
    $PS_VERSION = $PSVersionTable.PSVersion.Major
    $POWERSHELL7_PATH = Join-Path (Join-Path (Join-Path $Env:Programfiles "PowerShell") "7") "pwsh.exe"

    if ($PS_VERSION -eq 7) {
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Show-Elevate $commandPath $PS_VERSION
            Start-Process $POWERSHELL7_PATH "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
            exit
        }
    }
    else {
        Show-Elevate $commandPath $PS_VERSION
        Start-Process $POWERSHELL7_PATH "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
        exit
    }

}