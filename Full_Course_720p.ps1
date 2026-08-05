<#
.SYNOPSIS
    Downloads a YouTube video at up to 720p with embedded chapters and English subtitles.
.DESCRIPTION
    Relies on yt-dlp and ffmpeg being installed on the system.
#>

$VideoUrl = "https://www.youtube.com/watch?v=DR4QhvIlFfQ"
$OutputFilename = "%(title)s_720p.%(ext)s"

# 1. Verify yt-dlp is installed
if (-not (Get-Command "yt-dlp" -ErrorAction SilentlyContinue)) {
    Write-Warning "yt-dlp is not installed or not in your PATH."
    Write-Host "On macOS, install it by running: brew install yt-dlp" -ForegroundColor Yellow
    exit
}

# 2. Verify ffmpeg is installed (Required for chapters and subtitles)
if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue)) {
    Write-Warning "ffmpeg is not installed."
    Write-Host "On macOS, install it by running: brew install ffmpeg" -ForegroundColor Yellow
    exit
}

Write-Host "Starting download for: $VideoUrl" -ForegroundColor Cyan
Write-Host "Settings: Max 720p | Chapters: Yes | Subtitles: English (Auto/Manual)" -ForegroundColor Cyan
Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray

# 3. Define yt-dlp arguments
# -f : Selects best video up to 720p and best audio, preferring mp4/m4a
# --embed-chapters : Adds chapter markers to the final file
# --write-subs / --write-auto-subs : Grabs manual subs, falls back to auto-generated
# --sub-langs "en" : Specifies English subtitles (change to "all" for all languages)
# --embed-subs : Bakes the subtitles directly into the video file (soft subs)
# --merge-output-format mp4 : Ensures the final container is an MP4

$ytArgs = @(
    "-f", "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best",
    "--embed-chapters",
    "--write-subs",
    "--write-auto-subs",
    "--sub-langs", "en",
    "--embed-subs",
    "--merge-output-format", "mp4",
    "-o", $OutputFilename,
    $VideoUrl
)

# 4. Execute the download command
& yt-dlp $ytArgs

# 5. Check if the download was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDownload completed successfully!" -ForegroundColor Green
} else {
    Write-Error "`nDownload failed with exit code $LASTEXITCODE"
}