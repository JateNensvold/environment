#!/usr/bin/env pwsh
# mklink %APPDATA%\ConEmu.xml
$PARENT_DIRECTORY = $PSScriptRoot
$ENVIRONMENT_DIRECTORY = (get-item $PARENT_DIRECTORY).Parent.FullName

$SETTINGS_FILEPATH = Join-Path -Path $ENVIRONMENT_DIRECTORY -ChildPath "settings" "conemu" "settings.xml"

Write-Output $SETTINGS_FILEPATH
