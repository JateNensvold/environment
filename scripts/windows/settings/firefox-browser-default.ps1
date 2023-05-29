#Requires -Version 7.0
#Requires -RunAsAdministrator

# Found code from here https://www.c-sharpcorner.com/article/set-default-browser-to-microsoft-edge-using-powershell/
$Path = (Get-ItemProperty `
        HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice `
        -Name ProgId).ProgId
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$Name = "DefaultAssociationsConfiguration"
$result = "FirefoxURL-308046B0AF4A39CB"
$DEFAULT_BROWSER_XML_PATH = Join-Path $PSScriptRoot "default-browser.xml"

if ($Path -eq $result) {
    New-ItemProperty -Path $registryPath -Name $name -Value $DEFAULT_BROWSER_XML_PATH -PropertyType String `
        -Force | Out-Null
}
else {
    exit
}