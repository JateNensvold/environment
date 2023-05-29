#Requires -Version 5.0

# The following two functions are used to bootstrap the safe installation of the environment repo.
#   They are also downloaded duriong the repo installation and can be found as a module under
#   scripts/windows/lib/File-Command.psm1
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

# Download Repo https://askubuntu.com/questions/939830/how-to-download-a-github-repo-as-zip-using-command-line
# Invoke-WebRequest https://github.com/JateNensvold/environment/archive/master.zip

# Download windows-install.ps1 file
# Invoke-WebRequest https://github.com/JateNensvold/environment/contents/windows-install.ps1 | Invoke-Expression windows-install.ps1

$REPOSITORY_ZIP_NAME = "environment-master-temp.zip"
$REPOSITORY_PARENT_FOLDER = "environment-master-temp"
$REPOSITORY_UNZIPED_NAME = "environment-master"
$REPOSITORY_NAME = "environment"
$REPOSITORY_BACKUP_NAME = "environment_backup"
$SCRIPTS_FOLDER_NAME = "scripts"
$WINDOWS_SETUP_SCRIPT_NAME = "windows-setup.ps1"
$REPOSITORY_URL = "https://github.com/JateNensvold/environment/archive/master.zip"

# Change path to current user directory
Resolve-Path ~ | Set-Location
$EXECUTION_DIRECTORY = Get-Location

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Setting Location: " -NoNewline -ForegroundColor Green
Write-Host $EXECUTION_DIRECTORY -ForegroundColor Cyan

# Download Environment Git repo as a zip
Write-Host "Downloading: " -ForegroundColor Green -NoNewline
Write-Host $REPOSITORY_ZIP_NAME -ForegroundColor Cyan -NoNewline
Write-Host " from: " -ForegroundColor Green -NoNewline
Write-Host $REPOSITORY_URL -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow
Invoke-WebRequest $REPOSITORY_URL -OutFile $REPOSITORY_ZIP_NAME


# Unzip Git repo
Expand-Archive $REPOSITORY_ZIP_NAME -DestinationPath $REPOSITORY_PARENT_FOLDER

$REPOSITORY_UNZIPPED_PATH = Join-Path $REPOSITORY_PARENT_FOLDER $REPOSITORY_UNZIPED_NAME

Export-File $REPOSITORY_NAME $REPOSITORY_BACKUP_NAME -Force
mv $REPOSITORY_UNZIPPED_PATH $REPOSITORY_NAME
rm $REPOSITORY_ZIP_NAME
rm -r $REPOSITORY_PARENT_FOLDER

# Need to use multiple Join-path for Powershell 5
$REPOSITORY_ABSOLUTE_PATH = Join-Path $EXECUTION_DIRECTORY $REPOSITORY_NAME
$WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH = (Join-Path $REPOSITORY_ABSOLUTE_PATH (
        Join-Path $SCRIPTS_FOLDER_NAME $WINDOWS_SETUP_SCRIPT_NAME))

Write-Host "Unziped and moved repository to: " -ForegroundColor Green -NoNewline
Write-Host $REPOSITORY_ABSOLUTE_PATH -ForegroundColor Cyan
Write-Host "Executing: " -ForegroundColor Green -NoNewline
Write-Host $WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH -ForegroundColor Cyan
Write-Host "------------------------------------" -ForegroundColor Yellow

Write-Host "Running windows setup scripts..." -ForegroundColor Yellow

& $WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH