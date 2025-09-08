# SpeedTest CLI Installer
# Alternative installation method

param(
    [switch]$Force,
    [string]$InstallPath
)

Write-Host "SpeedTest CLI Installer" -ForegroundColor Blue
Write-Host "======================" -ForegroundColor Blue

try {
    # Download the main script
    $scriptUrl = "https://speedtest.pages.dev/speedtest.ps1"
    Write-Host "Downloading SpeedTest CLI..." -ForegroundColor Yellow
    
    $scriptContent = Invoke-RestMethod -Uri $scriptUrl
    
    # Execute with install flag
    $scriptBlock = [ScriptBlock]::Create("$scriptContent -Install")
    & $scriptBlock
    
    Write-Host "`nInstallation completed successfully!" -ForegroundColor Green
    Write-Host "You can now use 'speedtest' command from anywhere." -ForegroundColor Green
    
} catch {
    Write-Error "Installation failed: $($_.Exception.Message)"
    Write-Host "`nTry manual installation:" -ForegroundColor Yellow
    Write-Host "1. Download: https://speedtest.pages.dev/speedtest.ps1" -ForegroundColor Cyan
    Write-Host "2. Run: .\speedtest.ps1 -Install" -ForegroundColor Cyan
}