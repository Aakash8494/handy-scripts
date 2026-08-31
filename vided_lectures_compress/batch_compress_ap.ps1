param(
    [Parameter(Mandatory = $true)][string]$SourceDir,
    [Parameter(Mandatory = $true)][string]$DestDir,
    [Parameter(Mandatory = $false)][string]$LogFile
)

# Set default log file path if none is provided
if (-Not $LogFile) {
    $LogFile = Join-Path -Path $DestDir -ChildPath "failed_compressions.txt"
}

# Set console encoding to UTF-8 to properly display Hindi characters
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (-Not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir | Out-Null
}

# Initialize/touch the log file with a header for this run
$runStartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $LogFile -Value "`n--- New Compression Run Started at $runStartTime ---"

# Sort-Object ensures files are processed alphabetically
$files = Get-ChildItem -Path $SourceDir -Filter "*.mp4" -Recurse | Sort-Object -Property FullName

foreach ($file in $files) {
    $sourceRoot = (Get-Item $SourceDir).FullName
    $relativePath = $file.FullName.Substring($sourceRoot.Length + 1)
    
    $outputFile = Join-Path -Path $DestDir -ChildPath $relativePath
    $outputDir = Split-Path -Path $outputFile -Parent

    # Check if the compressed file already exists
    if (Test-Path $outputFile) {
        Write-Host "Skipping: $relativePath (already exists)" -ForegroundColor Yellow
        # Delete original if the compressed file is already safely in the destination
        Write-Host "Cleaning up original: $($file.Name)" -ForegroundColor DarkGray
        Remove-Item -Path $file.FullName -Force
        continue
    }

    if (-Not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }

    Write-Host "Compressing: $relativePath" -ForegroundColor Cyan
    
    # Run FFmpeg
    ffmpeg -i "$($file.FullName)" `
        -c:v hevc_videotoolbox `
        -r 15 `
        -b:v 120k `
        -c:a aac -b:a 32k -ac 1 `
        -y `
        "$outputFile"

    # SAFETY CHECK: Only delete if FFmpeg exited normally (0) AND the output file exists
    if ($LASTEXITCODE -eq 0 -and (Test-Path $outputFile)) {
        Write-Host "Compression successful. Deleting original: $($file.Name)" -ForegroundColor Green
        Remove-Item -Path $file.FullName -Force
    }
    else {
        Write-Host "Error or interruption during compression of $($file.Name). Original file kept." -ForegroundColor Red
        
        # LOGGING FAILURE
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $errorMessage = "[$timestamp] FAILED: $($file.FullName)"
        Add-Content -Path $LogFile -Value $errorMessage
    }
}

Write-Host "Scanning for empty folders to clean up..." -ForegroundColor Cyan

# Get all directories in the source, sorting by path length descending (deepest folders first)
$folders = Get-ChildItem -Path $SourceDir -Directory -Recurse | Sort-Object -Property @{Expression = { $_.FullName.Length }; Descending = $true }

foreach ($folder in $folders) {
    # Check if the folder is completely empty (including hidden files)
    $folderContents = Get-ChildItem -Path $folder.FullName -Force
    if ($folderContents.Count -eq 0) {
        Write-Host "Deleting empty folder: $($folder.Name)" -ForegroundColor DarkGray
        Remove-Item -Path $folder.FullName -Force
    }
}

Write-Host "Batch compression and cleanup complete! Check $LogFile for any errors." -ForegroundColor Green