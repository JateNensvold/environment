#Requires -Version 5.0

# Module Imports #################################
$LIB_FOLDER_NAME = "lib"
$WINDOWS_FOLDER_NAME = "windows"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path $PSScriptRoot (Join-Path $WINDOWS_FOLDER_NAME $LIB_FOLDER_NAME)

$CONFIRM_COMMAND_MODULE = "Confirm-Command.psm1"
$INVOKE_ADMINISTRATOR_MODULE = "Invoke-Administrator.psm1"
$GET_INSTALLED_MODULE = "Get-Installed.psm1"
$FILE_COMMAND_MODULE = "File-Command.psm1"

Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $CONFIRM_COMMAND_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $INVOKE_ADMINISTRATOR_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $GET_INSTALLED_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $FILE_COMMAND_MODULE) -Force
###################################################

# Elevate powershell to Administartor if it is not already
Invoke-Administrator $PSCommandPath

Invoke-File windows "chocolatey-install.ps1"
$PS_VERSION = $PSVersionTable.PSVersion.Major
# Skip upgrading powershell if already on version 7
if ($PS_VERSION -eq 5) {

    Invoke-File windows "powershell-upgrade.ps1"
}


# Elevate to powershell 7 for running the rest of the upgrade commands
Invoke-Administrator7 $PSCommandPath
Invoke-File windows "applications-install.ps1"
Invoke-File windows "windows-remove-UWP-apps.ps1"
Invoke-File windows "wsl-install.ps1"
Invoke-File windows "windows-settings.ps1"

# Invoke-File windows "windows-update.ps1"
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');