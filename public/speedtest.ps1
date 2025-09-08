# SpeedTest CLI - Internet Speed Test Tool
# Version: 1.0.0
# Author: Raju

param(
    [switch]$Install,
    [switch]$Uninstall,
    [switch]$Help,
    [switch]$Verbose,
    [int]$Duration = 10,
    [string]$Server,
    [switch]$Simple
)

# Global variables
$Script:ScriptName = "speedtest"
$Script:ScriptPath = "$env:USERPROFILE\.local\bin\$Script:ScriptName.ps1"
$Script:UserBinDir = "$env:USERPROFILE\.local\bin"

function Show-Help {
    Write-Host @"
SpeedTest CLI - Internet Speed Test Tool

USAGE:
    speedtest [OPTIONS]

OPTIONS:
    -Install        Install the speedtest command globally
    -Uninstall      Remove the speedtest command
    -Help           Show this help message
    -Verbose        Show detailed output
    -Duration <n>   Test duration in seconds (default: 10)
    -Server <url>   Custom test server URL
    -Simple         Simple output format

EXAMPLES:
    speedtest                    # Run basic speed test
    speedtest -Verbose           # Run with detailed output
    speedtest -Duration 15       # Run 15-second test
    speedtest -Install           # Install globally
    speedtest -Simple            # Minimal output

INSTALLATION:
    To install: irm https://your-domain.com/speedtest.ps1 | iex
    Or run: speedtest -Install
"@
}

function Install-SpeedTest {
    try {
        Write-Host "Installing SpeedTest CLI..." -ForegroundColor Yellow
        
        # Create user bin directory
        if (-not (Test-Path $Script:UserBinDir)) {
            New-Item -ItemType Directory -Path $Script:UserBinDir -Force | Out-Null
        }
        
        # Copy script to user bin
        $currentScript = $PSCommandPath
        if (-not $currentScript) {
            # If running from downloaded content, save the script
            $scriptContent = Get-Content $MyInvocation.ScriptName -Raw
            $scriptContent | Out-File -FilePath $Script:ScriptPath -Encoding UTF8
        } else {
            Copy-Item $currentScript $Script:ScriptPath -Force
        }
        
        # Add to PATH if not already there
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath -notlike "*$Script:UserBinDir*") {
            $newPath = "$userPath;$Script:UserBinDir"
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Write-Host "Added to PATH: $Script:UserBinDir" -ForegroundColor Green
        }
        
        # Create batch wrapper for easier execution
        $batchWrapper = @"
@echo off
powershell.exe -ExecutionPolicy Bypass -File "$Script:ScriptPath" %*
"@
        $batchPath = "$Script:UserBinDir\$Script:ScriptName.bat"
        $batchWrapper | Out-File -FilePath $batchPath -Encoding ASCII
        
        Write-Host "SpeedTest CLI installed successfully!" -ForegroundColor Green
        Write-Host "You can now use 'speedtest' command from anywhere." -ForegroundColor Green
        Write-Host "Note: You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
        
    } catch {
        Write-Error "Installation failed: $($_.Exception.Message)"
    }
}

function Uninstall-SpeedTest {
    try {
        Write-Host "Uninstalling SpeedTest CLI..." -ForegroundColor Yellow
        
        # Remove script files
        if (Test-Path $Script:ScriptPath) {
            Remove-Item $Script:ScriptPath -Force
        }
        if (Test-Path "$Script:UserBinDir\$Script:ScriptName.bat") {
            Remove-Item "$Script:UserBinDir\$Script:ScriptName.bat" -Force
        }
        
        Write-Host "SpeedTest CLI uninstalled successfully!" -ForegroundColor Green
        
    } catch {
        Write-Error "Uninstallation failed: $($_.Exception.Message)"
    }
}

function Test-InternetConnection {
    try {
        $ping = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        return $ping
    } catch {
        return $false
    }
}

function Get-PublicIP {
    try {
        $ip = (Invoke-RestMethod -Uri "https://api.ipify.org" -TimeoutSec 5).Trim()
        return $ip
    } catch {
        try {
            $ip = (Invoke-RestMethod -Uri "https://ifconfig.me/ip" -TimeoutSec 5).Trim()
            return $ip
        } catch {
            return "Unable to determine"
        }
    }
}

function Get-LocationInfo {
    try {
        $info = Invoke-RestMethod -Uri "http://ip-api.com/json/" -TimeoutSec 5
        return @{
            ISP = $info.isp
            City = $info.city
            Country = $info.country
            Region = $info.regionName
        }
    } catch {
        return @{
            ISP = "Unknown"
            City = "Unknown"
            Country = "Unknown"
            Region = "Unknown"
        }
    }
}

function Measure-DownloadSpeed {
    param([string]$Url, [int]$DurationSeconds)
    
    $testUrls = @(
        "https://proof.ovh.net/files/100Mb.dat",
        "https://speed.cloudflare.com/__down?bytes=100000000",
        "https://www.googleapis.com/download/storage/v1/b/gcp-public-data-landsat/o/LC08%2F01%2F044%2F034%2F%2FLC08_L1GT_044034_20130330_20170310_01_T2%2FLC08_L1GT_044034_20130330_20170310_01_T2_MTL.txt?alt=media"
    )
    
    if ($Url) {
        $testUrls = @($Url)
    }
    
    $bestSpeed = 0
    $bestUrl = ""
    
    foreach ($testUrl in $testUrls) {
        try {
            if ($Verbose) {
                Write-Host "Testing download from: $testUrl" -ForegroundColor Cyan
            }
            
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $webClient = New-Object System.Net.WebClient
            $webClient.Headers.Add("User-Agent", "SpeedTest-CLI/1.0")
            
            $totalBytes = 0
            $buffer = New-Object byte[] 8192
            
            try {
                $stream = $webClient.OpenRead($testUrl)
                $endTime = $stopwatch.ElapsedMilliseconds + ($DurationSeconds * 1000)
                
                while ($stopwatch.ElapsedMilliseconds -lt $endTime) {
                    $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
                    if ($bytesRead -eq 0) { break }
                    $totalBytes += $bytesRead
                }
                
                $stream.Close()
            } finally {
                $webClient.Dispose()
            }
            
            $stopwatch.Stop()
            $seconds = $stopwatch.ElapsedMilliseconds / 1000
            $speed = ($totalBytes * 8) / $seconds / 1000000  # Mbps
            
            if ($speed -gt $bestSpeed) {
                $bestSpeed = $speed
                $bestUrl = $testUrl
            }
            
            if ($Verbose) {
                Write-Host "Speed: $([math]::Round($speed, 2)) Mbps" -ForegroundColor Green
            }
            
        } catch {
            if ($Verbose) {
                Write-Host "Failed to test $testUrl`: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    
    return @{
        Speed = $bestSpeed
        Url = $bestUrl
    }
}

function Measure-UploadSpeed {
    param([int]$DurationSeconds)
    
    $uploadUrls = @(
        "https://httpbin.org/post",
        "https://httpbin.org/put"
    )
    
    $bestSpeed = 0
    
    foreach ($url in $uploadUrls) {
        try {
            if ($Verbose) {
                Write-Host "Testing upload to: $url" -ForegroundColor Cyan
            }
            
            # Generate random data
            $data = [byte[]](1..8192 | ForEach-Object { Get-Random -Maximum 256 })
            
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $totalBytes = 0
            $endTime = $stopwatch.ElapsedMilliseconds + ($DurationSeconds * 1000)
            
            while ($stopwatch.ElapsedMilliseconds -lt $endTime) {
                try {
                    $response = Invoke-RestMethod -Uri $url -Method Post -Body $data -ContentType "application/octet-stream" -TimeoutSec 2
                    $totalBytes += $data.Length
                } catch {
                    break
                }
            }
            
            $stopwatch.Stop()
            $seconds = $stopwatch.ElapsedMilliseconds / 1000
            $speed = ($totalBytes * 8) / $seconds / 1000000  # Mbps
            
            if ($speed -gt $bestSpeed) {
                $bestSpeed = $speed
            }
            
            if ($Verbose) {
                Write-Host "Upload Speed: $([math]::Round($speed, 2)) Mbps" -ForegroundColor Green
            }
            
        } catch {
            if ($Verbose) {
                Write-Host "Failed to test upload to $url`: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
    
    return $bestSpeed
}

function Measure-Ping {
    try {
        $ping = Test-Connection -ComputerName "8.8.8.8" -Count 4
        $avgPing = ($ping | Measure-Object ResponseTime -Average).Average
        return [math]::Round($avgPing, 2)
    } catch {
        return 0
    }
}

function Show-Results {
    param($Results)
    
    if ($Simple) {
        Write-Host "Download: $([math]::Round($Results.Download, 2)) Mbps | Upload: $([math]::Round($Results.Upload, 2)) Mbps | Ping: $($Results.Ping) ms"
        return
    }
    
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║            SPEED TEST RESULTS            ║" -ForegroundColor Blue
    Write-Host "╠══════════════════════════════════════════╣" -ForegroundColor Blue
    Write-Host "║                                          ║" -ForegroundColor Blue
    Write-Host "║  Public IP:    $($Results.IP.PadRight(26)) ║" -ForegroundColor White
    Write-Host "║  ISP:          $($Results.ISP.PadRight(26)) ║" -ForegroundColor White
    Write-Host "║  Location:     $($Results.Location.PadRight(26)) ║" -ForegroundColor White
    Write-Host "║                                          ║" -ForegroundColor Blue
    Write-Host "║  Download:     $([math]::Round($Results.Download, 2).ToString().PadLeft(8)) Mbps        ║" -ForegroundColor Green
    Write-Host "║  Upload:       $([math]::Round($Results.Upload, 2).ToString().PadLeft(8)) Mbps        ║" -ForegroundColor Yellow
    Write-Host "║  Ping:         $($Results.Ping.ToString().PadLeft(8)) ms          ║" -ForegroundColor Cyan
    Write-Host "║                                          ║" -ForegroundColor Blue
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

# Main execution logic
if ($Help) {
    Show-Help
    exit
}

if ($Install) {
    Install-SpeedTest
    exit
}

if ($Uninstall) {
    Uninstall-SpeedTest
    exit
}

# Run speed test
Write-Host "SpeedTest CLI - Internet Speed Test Tool" -ForegroundColor Blue
Write-Host "=======================================" -ForegroundColor Blue

if (-not (Test-InternetConnection)) {
    Write-Error "No internet connection detected!"
    exit 1
}

if (-not $Simple) {
    Write-Host "Gathering connection information..." -ForegroundColor Yellow
}

$publicIP = Get-PublicIP
$locationInfo = Get-LocationInfo

if (-not $Simple) {
    Write-Host "Testing download speed..." -ForegroundColor Yellow
}
$downloadResult = Measure-DownloadSpeed -Url $Server -DurationSeconds $Duration

if (-not $Simple) {
    Write-Host "Testing upload speed..." -ForegroundColor Yellow
}
$uploadSpeed = Measure-UploadSpeed -DurationSeconds ($Duration / 2)

if (-not $Simple) {
    Write-Host "Testing ping..." -ForegroundColor Yellow
}
$ping = Measure-Ping

$results = @{
    IP = $publicIP
    ISP = $locationInfo.ISP
    Location = "$($locationInfo.City), $($locationInfo.Country)"
    Download = $downloadResult.Speed
    Upload = $uploadSpeed
    Ping = $ping
}

Show-Results -Results $results

# If this script is being run directly from a download, offer installation
if (-not $PSCommandPath -and -not $Install) {
    Write-Host ""
    Write-Host "To install this tool globally, run: speedtest -Install" -ForegroundColor Green
}