param(
    [Parameter(Mandatory=$true)][string]$SourceDir,
    [Parameter(Mandatory=$true)][string]$DestDir
)

if (-Not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir | Out-Null
}

$files = Get-ChildItem -Path $SourceDir -Filter "*.mp4" -Recurse

foreach ($file in $files) {
    $sourceRoot = (Get-Item $SourceDir).FullName
    $relativePath = $file.FullName.Substring($sourceRoot.Length + 1)
    
    $outputFile = Join-Path -Path $DestDir -ChildPath $relativePath
    $outputDir = Split-Path -Path $outputFile -Parent

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
}

Write-Host "Batch compression complete!" -ForegroundColor Green