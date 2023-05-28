# Download Repo https://askubuntu.com/questions/939830/how-to-download-a-github-repo-as-zip-using-command-line
# Invoke-WebRequest https://github.com/JateNensvold/environment/archive/master.zip

# Download windows-install.ps1 file
# Invoke-WebRequest https://github.com/JateNensvold/environment/contents/windows-install.ps1 | Invoke-Expression windows-install.ps1

# Change path to current user directory
Resolve-Path ~ | Set-Location
Write-Host "Setting Location: " -NoNewline -ForegroundColor Green
$EXECUTION_DIRECTORY = Get-Location

Write-Host $EXECUTION_DIRECTORY -ForegroundColor Yellow

$REPOSITORY_ZIP_NAME = "environment-master-temp.zip"
$REPOSITORY_PARENT_FOLDER = "environment-master-temp"
$REPOSITORY_UNZIPED_NAME = "environment-master"
$REPOSITORY_NAME = "environment"
$SCRIPTS_FOLDER_NAME = "scripts"
$WINDOWS_SETUP_SCRIPT_NAME = "windows-setup.ps1"
$REPOSITORY_URL = "https://github.com/JateNensvold/environment/archive/master.zip"

# Download Environment Git repo as a zip
Write-Host "Downloading: " -ForegroundColor Green -NoNewline
Write-Host $REPOSITORY_ZIP_NAME -ForegroundColor Yellow -NoNewline
Write-Host " from: " -ForegroundColor Gree -NoNewline
Write-Host $REPOSITORY_URL -ForegroundColor Yellow
Invoke-WebRequest $REPOSITORY_URL -OutFile $REPOSITORY_ZIP_NAME


# Unzip Git repo
Expand-Archive $REPOSITORY_ZIP_NAME -DestinationPath $REPOSITORY_PARENT_FOLDER

$REPOSITORY_UNZIPPED_PATH = Join-Path $REPOSITORY_PARENT_FOLDER $REPOSITORY_UNZIPED_NAME
mv $REPOSITORY_UNZIPPED_PATH $REPOSITORY_NAME

rm $REPOSITORY_ZIP_NAME
rm -r $REPOSITORY_PARENT_FOLDER

# Need to use multiple Join-path for Powershell 5
$REPOSITORY_ABSOLUTE_PATH = Join-Path $EXECUTION_DIRECTORY $REPOSITORY_NAME
$WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH = (Join-Path $REPOSITORY_ABSOLUTE_PATH (
        Join-Path $SCRIPTS_FOLDER_NAME $WINDOWS_SETUP_SCRIPT_NAME))

Write-Host "Unziped and moved repository to: " -ForegroundColor Green -NoNewline
Write-Host $REPOSITORY_ABSOLUTE_PATH -ForegroundColor Yellow


Write-Host "Executing: " -ForegroundColor Green -NoNewline
Write-Host $WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH -ForegroundColor Yellow
& $WINDOWS_SETUP_SCRIPT_ABSOLUTE_PATH