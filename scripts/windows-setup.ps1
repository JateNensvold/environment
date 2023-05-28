# Elevate powershell to Administartor if it is not already
# Set ExecutionPolicy to run "untrusted" scripts during setup
$LIB_FOLDER_NAME = "lib"
$WINDOWS_FOLDER_NAME = "windows"
$LIB_ABSOULTE_FOLDER_PATH = Join-Path $PSScriptRoot (Join-Path $WINDOWS_FOLDER_NAME $LIB_FOLDER_NAME)

$CONFIRM_COMMAND_MODULE = "Confirm-Command.psm1"
$INVOKE_ADMINISTRATOR_MODULE = "Invoke-Administrator.psm1"
$GET_INSTALLED_MODULE = "Get-Installed.psm1"
$INVOKE_FILE_MODULE = "Invoke-File.psm1"


Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $CONFIRM_COMMAND_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $INVOKE_ADMINISTRATOR_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $GET_INSTALLED_MODULE) -Force
Import-Module (Join-Path $LIB_ABSOULTE_FOLDER_PATH $INVOKE_FILE_MODULE) -Force

Invoke-Administrator $PSCommandPath

Invoke-File Windows "chocolatey-install.ps1"
$PS_VERSION = $PSVersionTable.PSVersion.Major
if ($PS_VERSION -eq 5) {
    Invoke-File Windows "powershell-upgrade.ps1"
}
# Invoke-File Windows "windows-remove-UWP-apps.ps1"
Invoke-Administrator7 $PSCommandPath

Invoke-File Windows "applications-install.ps1"

# $INSTALLED_SOFTWARE = Get-InstalledSoftware
# Write-Output $INSTALLED_SOFTWARE

# $INSTALLED_PROGRAMS = Get-InstalledPrograms
# $FILTERED_PROGRAMS = Select-List $INSTALLED_PROGRAMS ("vscode")
# Write-Host $FILTERED_PROGRAMS -ForegroundColor Green

# Invoke-File Windows "wsl-install.ps1"
# Invoke-File Windows "windows-update.ps1"
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');