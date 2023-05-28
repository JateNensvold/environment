# Elevate powershell to Administartor if it is not already
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
# Set ExecutionPolicy to run "untrusted" scripts during setup
Set-ExecutionPolicy Bypass -Scope Process -Force;

./windows/chocolatey-install.ps1