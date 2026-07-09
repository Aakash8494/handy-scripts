# 1. Create an output folder in the current directory
$outputFolder = Join-Path "." "BlackVideos"
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# 2. Get all MP4 files in the current directory
$files = Get-ChildItem -Filter "*.mp4" -File

# 3. Loop through and process each file
foreach ($file in $files) {
    $outputFile = Join-Path $outputFolder $file.Name
    
    Write-Host "Processing: $($file.Name)..." -ForegroundColor Cyan
    
    ffmpeg -i $file.FullName -f lavfi -i color=c=black:s=640x360:r=1 -map 1:v -map 0:a -c:a copy -c:v libx264 -preset ultrafast -shortest $outputFile -y
}

Write-Host "Batch conversion complete!" -ForegroundColor Green