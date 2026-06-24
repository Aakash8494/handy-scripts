# Directory to save the compressed files so we don't overwrite the originals
$outputDir = "compressed"

# Create the output directory if it doesn't already exist
if (-not (Test-Path $outputDir)) { 
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Find all MP4 files in the current folder and loop through them
Get-ChildItem -Filter *.mp4 | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = Join-Path $outputDir $_.Name

    # Check if the compressed file already exists to avoid double-processing
    if (-not (Test-Path $outputFile)) {
        Write-Host "Compressing: $($_.Name)..." -ForegroundColor Cyan
        
        # The FFmpeg compression command
        # -preset fast speeds up the h.265 encoding process slightly
        ffmpeg -i "$inputFile" -c:v libx265 -crf 28 -r 24 -preset fast -c:a aac -b:a 96k "$outputFile"
        
        Write-Host "Finished: $($_.Name)`n" -ForegroundColor Green
    }
    else {
        Write-Host "Skipping: $($_.Name) (Already compressed)" -ForegroundColor DarkGray
    }
}

Write-Host "All videos processed successfully!" -ForegroundColor Yellow