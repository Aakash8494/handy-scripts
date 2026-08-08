<#
pwsh /Users/aakashjadhav/Documents/GitHub/handy-scripts/Merge-GoFiles.ps1
.SYNOPSIS
    Gathers all .go files recursively and merges them into a single text file formatted for AI context.
#>

$OutputFileName = "_merged_go_code.txt"
$TargetDirectory = "." 

# 1. Delete the output file if it already exists from a previous run
if (Test-Path $OutputFileName) {
    Remove-Item $OutputFileName
}

Write-Host "Searching for .go files..." -ForegroundColor Cyan

# 2. Find all .go files recursively (ignoring any 'vendor' dependency folders)
$GoFiles = Get-ChildItem -Path $TargetDirectory -Filter *.go -Recurse -File | 
           Where-Object { $_.FullName -notmatch "[/\\]vendor[/\\]" }

if ($GoFiles.Count -eq 0) {
    Write-Warning "No .go files found in the current directory or subdirectories."
    exit
}

Write-Host "Found $($GoFiles.Count) files. Merging..." -ForegroundColor Cyan

# 3. Read each file and append it with a clear header
foreach ($file in $GoFiles) {
    # Calculate the relative path for cleaner output (e.g., "6_golang_concurrency/04_buffered_channels/main.go")
    $BasePath = (Resolve-Path $TargetDirectory).Path
    $RelativePath = $file.FullName.Replace($BasePath, "").TrimStart('\', '/')
    
    # Create a visible divider for the AI to understand file boundaries
    $Header = "`n" + ("=" * 80) + "`n"
    $Header += "File: $RelativePath`n"
    $Header += ("=" * 80) + "`n"
    
    # Read the code
    $Content = Get-Content -Path $file.FullName -Raw
    
    # Append to the final text file using UTF-8 encoding to preserve characters
    $Header + $Content | Add-Content -Path $OutputFileName -Encoding UTF8
}

Write-Host "Done! Your code is ready to be copied from: $OutputFileName" -ForegroundColor Green