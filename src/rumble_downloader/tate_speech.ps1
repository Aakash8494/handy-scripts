python -m yt_dlp `
    -P "C:\Users\aakas\Downloads" `
    -f "hls-675" `
    -o "%(uploader)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" `
    --embed-thumbnail `
    --convert-thumbnails jpg `
    --embed-metadata `
    --match-title "(?i)EMERGENCY MEETING" `
    "https://rumble.com/c/TateSpeech"