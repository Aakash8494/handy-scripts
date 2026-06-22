<#
.SYNOPSIS
A collection of media utilities to extract audio using FFmpeg and read media file lengths.

.DESCRIPTION
To use these tools, right-click the folder containing your videos, select "Open in Terminal" 
(or hold Shift + Right-click -> "Open PowerShell window here"), and run this script.
#>

# ==============================================================================
# 1. EXTRACT AUDIO (SINGLE FOLDER)
# ==============================================================================
function Convert-MediaToMp3 {
    param (
        [string[]]$Extensions = @('.mp4', '.webm', '.mkv')
    )
    Write-Host "Starting batch extraction in current folder..." -ForegroundColor Cyan
    Get-ChildItem -File | Where-Object Extension -in $Extensions | ForEach-Object { 
        $output = "$($_.BaseName).mp3"
        Write-Host "Processing: $($_.Name) -> $output" -ForegroundColor Yellow
        ffmpeg -i $_.FullName -q:a 0 -map a $output -y # -y overwrites without asking
    }
    Write-Host "Done!" -ForegroundColor Green
}

# ==============================================================================
# 2. EXTRACT AUDIO (RECURSIVE WITH SKIP CHECK)
# ==============================================================================
function Convert-MediaToMp3Recursive {
    param (
        [string[]]$Extensions = @('.mp4', '.webm', '.mkv')
    )
    Write-Host "Scanning all subfolders for media files..." -ForegroundColor Cyan
    Get-ChildItem -File -Recurse | Where-Object Extension -in $Extensions | ForEach-Object {
        $output = "$($_.DirectoryName)\$($_.BaseName).mp3"
        
        if (-not (Test-Path $output)) {
            Write-Host "Extracting audio for: $($_.Name)" -ForegroundColor Yellow
            ffmpeg -i $_.FullName -q:a 0 -map a $output
        } else {
            Write-Host "Skipping: $output already exists." -ForegroundColor DarkGray
        }
    }
    Write-Host "Recursive extraction complete!" -ForegroundColor Green
}

# ==============================================================================
# 3. LIST FILE NAMES AND MEDIA LENGTHS
# ==============================================================================
function Get-MediaLength {
    Write-Host "Fetching media durations..." -ForegroundColor Cyan
    $shell = New-Object -ComObject Shell.Application
    $folderPath = (Get-Location).Path
    $folder = $shell.Namespace($folderPath)
    
    $folder.Items() | Select-Object Name, @{
        Name="Duration"; 
        Expression={$folder.GetDetailsOf($_, 27)} # Property 27 is usually 'Length' in Windows
    } | Where-Object Duration -ne "" | Format-Table -AutoSize
}

# ==============================================================================
# UNRELATED UTILITIES
# ==============================================================================
# To activate your Python virtual environment, run:
# venv\Scripts\Activate.ps1