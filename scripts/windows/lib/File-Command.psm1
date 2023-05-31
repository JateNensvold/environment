#Requires -Version 5.0

function Invoke-File {
    param (
        [string]$dirName,
        [string]$fileName
        # [Parameter(Mandatory = $false)][switch] $scriptroot
    )

    $SCRIPT_RELATIVE_PATH = Join-Path $dirName $fileName
    $SCRIPT_ABSOULTE_PATH = Join-Path (
        get-item $psscriptroot).Parent.Parent.FullName $SCRIPT_RELATIVE_PATH
    Write-Host "Running script: " -NoNewline -ForegroundColor Green
    Write-Host $SCRIPT_ABSOULTE_PATH -ForegroundColor Cyan
    & $SCRIPT_ABSOULTE_PATH
}

function Initialize-link ($newLink, $existingFile) {
    if (Test-FilePath $newLink) {
        Write-Host "LinkAlreadyExists: Skipping Initialize-Link from $existingFile to $newLink" `
            -ForegroundColor Yellow
    }
    else {
        New-Item -Path $newLink -ItemType SymbolicLink -Value $existingFile
    }
}
# New-Item -Path \\wsl.localhost\Ubuntu\\home\tosh\environment -ItemType SymbolicLink -Value C:\Users\Nate\environment
function Test-FilePath($filePath) {
    $result = Test-Path -Path $filePath
    # Uncomment the line below to display if filePaths are being tested properly
    # Write-Host "$filePath is $result" -ForegroundColor Red
    return $result
}

function Export-File {
    param(
        [Parameter(Mandatory = $true)][string]$sourcePath,
        [Parameter(Mandatory = $true)][string]$targetPath,
        [Parameter(Mandatory = $false)][switch]$Force
    )
    if (Test-FilePath $sourcePath) {
        if ($Force) {
            if (Test-FilePath $targetPath) {
                rm -r $targetPath
            }
        }
        else {
            Write-Host "FileAlreadyExists: Skipping Export-File from $sourcePath to $targetPath" `
                -ForegroundColor Yellow
            return
        }
        mv $sourcePath $targetPath
    }
}