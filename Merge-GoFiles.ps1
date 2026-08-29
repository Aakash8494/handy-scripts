<#
.SYNOPSIS
    Gathers all source files recursively and merges them into a single text file formatted for AI context.
    Excludes common generated folders (node_modules, bin, .git) and binary/media file types.
#>

$OutputFileName = "_merged_code.txt"
$TargetDirectory = "." 

# 1. Delete the output file if it already exists from a previous run
if (Test-Path $OutputFileName) {
    Remove-Item $OutputFileName
}

Write-Host "Searching for files..." -ForegroundColor Cyan

# 2. Define exclusions
# Common directories to skip (Regex escaped where necessary)
$ExcludedDirs = @(
    "\.git", "node_modules", "vendor", "bin", "obj", "\.vscode", 
    "\.idea", "__pycache__", "dist", "build", "\.next", "venv", "env"
)
$DirRegex = "([/\\])($($ExcludedDirs -join '|'))([/\\]|$)"

# Common binary, media, and build files to skip
$ExcludedExts = @(
    "\.exe$", "\.dll$", "\.so$", "\.dylib$", "\.class$",          # Binaries
    "\.png$", "\.jpg$", "\.jpeg$", "\.gif$", "\.ico$", "\.svg$",  # Images
    "\.mp3$", "\.mp4$", "\.wav$", "\.mov$",                       # Media
    "\.pdf$", "\.zip$", "\.tar$", "\.gz$", "\.rar$", "\.7z$",     # Archives
    "\.woff$", "\.woff2$", "\.ttf$", "\.eot$",                    # Fonts
    "package-lock\.json$", "yarn\.lock$", "pnpm-lock\.yaml$"      # Lock files (optional, often too large for AI context)
)
$ExtRegex = "(?i)($($ExcludedExts -join '|'))"

# 3. Find all files and filter them
$FilesToMerge = Get-ChildItem -Path $TargetDirectory -Recurse -File | 
Where-Object { 
    $_.FullName -notmatch $DirRegex -and # Not in an excluded folder
    $_.Name -notmatch $ExtRegex -and # Not an excluded file extension/name
    $_.Name -ne ".DS_Store" -and # Not a macOS system file
    $_.Name -ne $OutputFileName                    # Not the output file itself
}

if ($FilesToMerge.Count -eq 0) {
    Write-Warning "No valid source files found in the current directory or subdirectories."
    exit
}

Write-Host "Found $($FilesToMerge.Count) files. Merging..." -ForegroundColor Cyan

# 4. Read each file and append it with a clear header
foreach ($file in $FilesToMerge) {
    # Calculate the relative path for cleaner output
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