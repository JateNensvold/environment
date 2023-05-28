function Remove-UWP {
    param (
        [string]$name
    )

    Write-Host "Removing UWP $name..." -ForegroundColor Yellow
    Get-AppxPackage $name | Remove-AppxPackage
    Get-AppxPackage $name | Remove-AppxPackage -AllUsers
}

Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.MSPaint"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "*549981C3F5F10*"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.BingWeather"
    "Microsoft.BingNews"
    "king.com.CandyCrushSaga"
    "Microsoft.Messaging"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "4DF9E0F8.Netflix"
    "Microsoft.GetHelp"
    "Microsoft.People"
    "Microsoft.YourPhone"
    "MicrosoftTeams"
    "Microsoft.Getstarted"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.WindowsMaps"
    "Microsoft.MixedReality.Portal"
    "Microsoft.SkypeApp")

foreach ($uwp in $uwpRubbishApps) {
    Remove-UWP $uwp
}