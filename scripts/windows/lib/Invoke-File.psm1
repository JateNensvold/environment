enum ScriptDirectories{
    Windows
    Ubuntu
}

function Invoke-File {
    param (
        [ScriptDirectories]$dirName,
        [string]$fileName
    )


    $SCRIPT_RELATIVE_PATH = Join-Path $dirName.ToString().ToLower() $fileName
    $SCRIPT_ABSOULTE_PATH = Join-Path (
        get-item $PSScriptRoot).Parent.Parent.FullName $SCRIPT_RELATIVE_PATH
    Write-Host "Running script: " -NoNewline -ForegroundColor Green
    Write-Host $SCRIPT_ABSOULTE_PATH -ForegroundColor Yellow
    # Write-Host "..." -ForegroundColor Yellow
    & $SCRIPT_ABSOULTE_PATH
}