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

$runStartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $LogFile -Value "`n--- New Compression Run Started at $runStartTime ---"

$files = Get-ChildItem -Path $SourceDir -Filter "*.mp4" -Recurse | Sort-Object -Property FullName

foreach ($file in $files) {
    $sourceRoot = (Get-Item $SourceDir).FullName
    $relativePath = $file.FullName.Substring($sourceRoot.Length + 1)
    
    $outputFile = Join-Path -Path $DestDir -ChildPath $relativePath
    $outputDir = Split-Path -Path $outputFile -Parent

    if (Test-Path $outputFile) {
        Write-Host "Skipping: $relativePath (already exists)" -ForegroundColor Yellow
        Write-Host "Cleaning up original: $($file.Name)" -ForegroundColor DarkGray
        Remove-Item -Path $file.FullName -Force
        continue
    }

    if (-Not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }

    Write-Host "Compressing: $relativePath" -ForegroundColor Cyan
    
    ffmpeg -i "$($file.FullName)" `
        -c:v hevc_videotoolbox `
        -r 15 `
        -b:v 120k `
        -c:a aac -b:a 32k -ac 1 `
        -y `
        "$outputFile"

    # --- NEW VERIFICATION BLOCK ---
    $isValid = $false
    $failReason = ""

    if ($LASTEXITCODE -eq 0 -and (Test-Path $outputFile)) {
        # 1. Check if file is larger than 1KB
        $fileSize = (Get-Item $outputFile).Length
        if ($fileSize -gt 1024) {
            # 2. Use ffprobe to check if it's a readable video file by querying its duration
            $probeOutput = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$outputFile" 2>&1
            
            # If ffprobe returns a number (duration in seconds), the file is structurally valid
            if ($probeOutput -match "\d+") {
                $isValid = $true
            }
            else {
                $failReason = "Corrupted output (ffprobe could not read media data)"
            }
        }
        else {
            $failReason = "File size too small ($fileSize bytes)"
        }
    }
    else {
        $failReason = "FFmpeg exit code $LASTEXITCODE or file missing"
    }
    # ------------------------------

    if ($isValid) {
        Write-Host "Compression successful and verified. Deleting original: $($file.Name)" -ForegroundColor Green
        Remove-Item -Path $file.FullName -Force
    }
    else {
        Write-Host "Error or corruption detected for $($file.Name). Original file kept." -ForegroundColor Red
        
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $errorMessage = "[$timestamp] FAILED: $($file.FullName) - Reason: $failReason"
        Add-Content -Path $LogFile -Value $errorMessage
        
        # Optional: Delete the broken output file so it tries again next time
        if (Test-Path $outputFile) {
            Remove-Item -Path $outputFile -Force
        }
    }
}

Write-Host "Scanning for empty folders to clean up..." -ForegroundColor Cyan

$folders = Get-ChildItem -Path $SourceDir -Directory -Recurse | Sort-Object -Property @{Expression = { $_.FullName.Length }; Descending = $true }

foreach ($folder in $folders) {
    $folderContents = Get-ChildItem -Path $folder.FullName -Force
    if ($folderContents.Count -eq 0) {
        Write-Host "Deleting empty folder: $($folder.Name)" -ForegroundColor DarkGray
        Remove-Item -Path $folder.FullName -Force
    }
}

Write-Host "Batch compression and cleanup complete! Check $LogFile for any errors." -ForegroundColor Green