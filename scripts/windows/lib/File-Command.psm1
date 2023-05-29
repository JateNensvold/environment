# enum ScriptDirectories{
#     Windows
#     Ubuntu
# }

function Invoke-File {
    param (
        [string]$dirName,
        [string]$fileName
    )

    $SCRIPT_RELATIVE_PATH = Join-Path $dirName $fileName
    $SCRIPT_ABSOULTE_PATH = Join-Path (
        get-item $PSScriptRoot).Parent.Parent.FullName $SCRIPT_RELATIVE_PATH
    Write-Host "Running script: " -NoNewline -ForegroundColor Green
    Write-Host $SCRIPT_ABSOULTE_PATH -ForegroundColor Cyan
    & $SCRIPT_ABSOULTE_PATH
}

function Initialize-link ($newLink, $existingFile) {
    if (Test-FilePath $newLink) {
        Write-Host "LinkAlreadyExists: Skipping Initialize-Link from $existingFile to $newLink" -ForegroundColor Yellow
    }
    else {
        New-Item -Path $newLink -ItemType SymbolicLink -Value $existingFile
    }
}

function Test-FilePath($filePath) {
    $result = Test-Path -Path $filePath
    Write-Host "$filePath is $result" -ForegroundColor Red
    return $result
}

function Export-File {
    param(
        [Parameter(Mandatory = $true)][string]$sourcePath,
        [Parameter(Mandatory = $true)][string]$targetPath,
        [Parameter(Mandatory = $false)][switch]$Force
    )
    if (Test-FilePath $sourcePath) {
        if ($Force)
        {
            rm $targetPath
        } else {
            Write-Host "FileAlreadyExists: Skipping Export-File from $sourcePath to $targetPath" -ForegroundColor Yellow
            return
        }
        mv $sourcePath $targetPath
    }
}