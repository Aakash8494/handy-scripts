# direct paste - batch folder - hardware accelerated compress - ffmpeg - hevc_qsv - 15fps - 64k mono audio - RECURSIVE
Get-ChildItem -Filter "*.mp4" -Recurse | Where-Object { $_.Name -notmatch "_Compressed" } | ForEach-Object {
    $newName = Join-Path -Path $_.DirectoryName -ChildPath ($_.BaseName + "_Compressed" + $_.Extension)
    ffmpeg -i $_.FullName -c:v hevc_qsv -global_quality 30 -preset slow -r 15 -c:a aac -b:a 64k -ac 1 $newName
}

