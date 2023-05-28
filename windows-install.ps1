# Download Repo https://askubuntu.com/questions/939830/how-to-download-a-github-repo-as-zip-using-command-line
# Invoke-WebRequest https://github.com/JateNensvold/environment/archive/master.zip

# Download windows-install.ps1 file
# Invoke-WebRequest https://github.com/JateNensvold/environment/contents/windows-install.ps1 | Invoke-Expression windows-install.ps1

# Change path to current user directory
Resolve-Path ~ | Set-Location

$REPOSITORY_ZIP_NAME = "environment-master-temp.zip"
$REPOSITORY_PARENT_FOLDER = "environment-master-temp"
$REPOSITORY_UNZIPED_NAME = "environment-master"
$REPOSITORY_NAME = "environment"
$SCRIPTS_FOLDER_NAME = "scripts"
$WINDOWS_SCRIPTS_FOLDER_NAME = "windows"
$WINDOWS_SETUP_SCRIPT_NAME = "windows-setup.ps1"

# Download Environment Git repo as a zip
Invoke-WebRequest https://github.com/JateNensvold/environment/archive/master.zip -OutFile $REPOSITORY_ZIP_NAME

# Unzip Git repo
Expand-Archive $REPOSITORY_ZIP_NAME -DestinationPath $REPOSITORY_PARENT_FOLDER

$REPOSITYR_UNZIPPED_PATH = Join-Path $REPOSITORY_PARENT_FOLDER $REPOSITORY_UNZIPED_NAME
mv $REPOSITYR_UNZIPPED_PATH $REPOSITORY_NAME

rm $REPOSITORY_ZIP_NAME
rm -r $REPOSITORY_PARENT_FOLDER

# Need to use multiple Join-path for Powershell 5
$WINDOWS_SETUP_SCRIPT_RELATIVE_PATH = (Join-Path (Join-Path $REPOSITORY_NAME $SCRIPTS_FOLDER_NAME) (Join-Path $WINDOWS_SCRIPTS_FOLDER_NAME $WINDOWS_SETUP_SCRIPT_NAME))
$WINDOWS_SETUP_SCRIPT_ABSOULTE_PATH = Join-Path $PSScriptRoot $WINDOWS_SETUP_SCRIPT_RELATIVE_PATH

& $WINDOWS_SETUP_SCRIPT_ABSOULTE_PATH