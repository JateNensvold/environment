#Requires -Version 7.0
#Requires -RunAsAdministrator

$LIB_FOLDER_NAME = "lib"
$CONFIRM_COMMAND_FILE = "Confirm-Command.psm1"
Import-Module (Join-Path $PSScriptRoot (Join-Path $LIB_FOLDER_NAME $CONFIRM_COMMAND_FILE))

$WINDOWS_TOOLS_FILE_NAME = "windows-tools.json"
$WINDOWS_SCRIPTS_DIRECTORY_PATH = $PSScriptRoot

# Load the list of windows tools to install
$JSON_OBJECT = Get-Content -Raw -Path (
    Join-Path $WINDOWS_SCRIPTS_DIRECTORY_PATH $WINDOWS_TOOLS_FILE_NAME) | ConvertFrom-Json

# Fetch just the tools list from the Json Object
$TOOLS_LIST = $JSON_OBJECT.tools

# Fetch installed programs listed by choco
$INSTALLED_PROGRAMS = Get-InstalledPrograms
$FILTERED_PROGRAMS = Select-List $INSTALLED_PROGRAMS $TOOLS_LIST

# Fetch installed software listed by windows
$INSTALLED_SOFTWARE = Get-InstalledSoftware
$FILTERED_SOFTWARE = Select-List $INSTALLED_SOFTWARE $TOOLS_LIST

# Merge the list so only installed software is shown
$INSTALLED_LIST = ($FILTERED_PROGRAMS + $FILTERED_SOFTWARE) | `
    Sort-Object -Property "choco_name" -Unique

$INSTALLED_HASH_MAP = @{}
foreach ($installed in $INSTALLED_LIST) {
    $INSTALLED_HASH_MAP.Add($installed.choco_name, $installed)
}

$NOT_INSTALLLED_LIST = @()

foreach ($tool in $TOOLS_LIST) {
    if (-Not ($INSTALLED_HASH_MAP.ContainsKey($tool.choco_name))) {
        $NOT_INSTALLLED_LIST += $tool
    }
}

if ($NOT_INSTALLLED_LIST.Count -gt 0) {
    $CHOCO_INSTALL_LIST = $NOT_INSTALLLED_LIST | `
        Join-String -Property { $_.choco_name } -Separator ";"
    Write-Host "------------------------------------" -ForegroundColor Yellow
    Write-Host "Installing the following programs: " -ForegroundColor Green -NoNewline
    Write-Host "$CHOCO_INSTALL_LIST" -ForegroundColor Yellow
    Write-Host "------------------------------------" -ForegroundColor Yellow
    #Install all programs not yet installed
    choco install $CHOCO_INSTALL_LIST -y
}
else {
    $INSTALLED_LIST_STRING = $INSTALLED_LIST | `
        Join-String -Property { $_.choco_name } -Separator ", "
    Write-Host "------------------------------------" -ForegroundColor Yellow
    Write-Host "All Applications are already installed" -ForegroundColor Green
    Write-Host "$INSTALLED_LIST_STRING" -ForegroundColor cyan
    Write-Host "------------------------------------" -ForegroundColor Yellow
}

