# 1. Define your main root download folder
$BaseDownloadFolder = "C:\Users\aakas\Downloads\YTDL_Downloads"

# 2. List of channels with their custom playlist-end limits
$channels = @(
    @{ Url = "https://www.youtube.com/@bettermanadvice"; PlaylistEnd = 40 },
    @{ Url = "https://www.youtube.com/@KEYFACTS33"; PlaylistEnd = 10 },
    @{ Url = "https://www.youtube.com/@mind_change12"; PlaylistEnd = 20 },
    @{ Url = "https://www.youtube.com/@sahajtloi"; PlaylistEnd = 20 },
    @{ Url = "https://www.youtube.com/@snagar86"; PlaylistEnd = 5 },
    @{ Url = "https://www.youtube.com/@IronWilll2026"; PlaylistEnd = 20 },
    @{ Url = "https://rumble.com/c/TateSpeech"; PlaylistEnd = 50 },

    
)

# 3. Loop through each channel block
foreach ($channel in $channels) {
    
    # Grab the URL and the Limit from the current block
    $url = $channel.Url
    $limit = $channel.PlaylistEnd
    
    # Extract the folder name from the URL and clean up the '@' symbol
    $FolderName = $url.Split('/')[-1].Replace('@', '')
    
    # Construct the full paths
    $ChannelFolder = Join-Path -Path $BaseDownloadFolder -ChildPath $FolderName
    $ArchivePath = Join-Path -Path $ChannelFolder -ChildPath "archive.txt"
    
    # Create the folder if it doesn't exist yet
    if (-not (Test-Path -Path $ChannelFolder)) {
        New-Item -ItemType Directory -Path $ChannelFolder | Out-Null
    }

    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "Starting download for: $url" -ForegroundColor Green
    Write-Host "Downloading maximum of: $limit videos" -ForegroundColor DarkCyan
    Write-Host "Extracted Folder: $FolderName" -ForegroundColor Magenta
    Write-Host "Saving archive to: $ArchivePath" -ForegroundColor Yellow
    
    # 4. Run yt-dlp using the custom limit variable
    python -m yt_dlp `
        -P "$ChannelFolder" `
        -f "bestvideo[height<=360]+bestaudio/best[height<=360]/best" `
        --merge-output-format mkv `
        --playlist-end $limit `
        --concurrent-fragments 4 `
        --download-archive "$ArchivePath" `
        -o "%(upload_date)s - %(title)s [%(id)s].%(ext)s" `
        --embed-thumbnail `
        --convert-thumbnails jpg `
        --embed-metadata `
        $url
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "All channels processed successfully!" -ForegroundColor Cyan