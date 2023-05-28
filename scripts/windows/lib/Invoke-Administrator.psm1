function Invoke-Administrator($commandPath) {
    $PS_VERSION = $PSVersionTable.PSVersion.Major
    Write-Output "Powershell Version: $PS_VERSION Command: $commandPath"

    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
        exit
    }
}

function Invoke-Administrator7($commandPath) {
    $PS_VERSION = $PSVersionTable.PSVersion.Major
    Write-Output "Powershell Version: $PS_VERSION Command: $commandPath"
    $POWERSHELL7_PATH = Join-Path (Join-Path (Join-Path $Env:Programfiles "PowerShell") "7") "pwsh.exe"

    if ($PS_VERSION -eq 7) {
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Start-Process $POWERSHELL7_PATH "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
            exit
        }
    }
    else {
        Start-Process $POWERSHELL7_PATH "-NoProfile -ExecutionPolicy Bypass -File `"$commandPath`"" -Verb RunAs;
        exit
    }

}