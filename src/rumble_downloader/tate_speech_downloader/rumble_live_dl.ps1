<#
.SYNOPSIS
    Downloads videos from a given Rumble URL at a specified maximum resolution using yt-dlp.
#>

param (
    [string]$Url = "https://rumble.com/c/TateSpeech/videos",
    [int]$MaxHeight = 360
)

# 1. Verify yt-dlp is installed and accessible in the system PATH
if (-not (Get-Command "yt-dlp" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: yt-dlp is not installed or not found in your PATH." -ForegroundColor Red
    Write-Host "Please install it using: winget install yt-dlp" -ForegroundColor Yellow
    exit 1
}

# 2. Define the format string. 
# This tells yt-dlp: "Get the best video <= 360p and best audio, OR the best single file <= 360p"
$FormatString = "bestvideo[height<=$MaxHeight]+bestaudio/best[height<=$MaxHeight]"

Write-Host "Target URL: $Url" -ForegroundColor Cyan
Write-Host "Target Quality: Max ${MaxHeight}p" -ForegroundColor Cyan
Write-Host "Starting yt-dlp..." -ForegroundColor Green
Write-Host "---------------------------------------------------"

# 3. Execute yt-dlp
# Added --no-warnings to keep the console clean, and --restrict-filenames to avoid weird characters in the saved files
yt-dlp -f $FormatString --restrict-filenames $Url

Write-Host "---------------------------------------------------"
Write-Host "Download process complete!" -ForegroundColor Green