#Requires -Version 5.0
#Requires -RunAsAdministrator

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Installing WSL." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Yellow
# Install WSL
wsl --install --no-launch

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Installing Ubuntu on WSL." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Yellow
# Install Ubuntu
Start-Process -FilePath wsl.exe -ArgumentList "--install -d Ubuntu --no-launch" -Wait -PassThru

Write-Host "------------------------------------" -ForegroundColor Yellow
Write-Host "Follow the instructions that pop up to setup Ubuntu on WSL." -ForegroundColor Green
Write-Host "To continue with setup afterwards close the prompt once Ubuntu has been initialized" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Yellow
# Setup Ubuntu
Start-Process -FilePath ubuntu.exe -Wait -PassThru