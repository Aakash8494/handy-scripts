# Define the video extensions you want to process
$videoExtensions = @('.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v')

# 1. Create an output folder in the current directory
$outputFolder = Join-Path "." "BlackVideos"
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# 2. Get all video files in the current directory matching the extensions
$files = Get-ChildItem -File | Where-Object { $_.Extension.ToLower() -in $videoExtensions }

# 3. Loop through and process each file
foreach ($file in $files) {
    # It is highly recommended to output everything to .mkv to avoid audio codec incompatibility
    $outputFileName = $file.BaseName + ".mkv" 
    $outputFile = Join-Path $outputFolder $outputFileName
    
    Write-Host "Processing: $($file.Name) -> $outputFileName..." -ForegroundColor Cyan
    
    ffmpeg -i $file.FullName -f lavfi -i color=c=black:s=640x360:r=1 -map 1:v -map 0:a -c:a copy -c:v libx264 -preset ultrafast -shortest $outputFile -y
}

Write-Host "Batch conversion complete!" -ForegroundColor Green