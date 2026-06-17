python -m yt_dlp `
    -P "C:\Users\aakas\Downloads" `
    -f "bestvideo[height<=360]+bestaudio/best[height<=360]/best" `
    --merge-output-format mkv `
    --playlist-end 40 `
    --concurrent-fragments 4 `
    --download-archive KEYFACTS33.txt `
    -o "%(uploader)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" `
    --embed-thumbnail `
    --convert-thumbnails jpg `
    --embed-metadata `
    "https://www.youtube.com/@KEYFACTS33/videos"


# single video download
# python -m yt_dlp `
#     -P "C:\Users\aakas\Downloads" `
#     -f "bestvideo[height<=480]+bestaudio/best[height<=480]/best" `
#     --merge-output-format mkv `
#     --concurrent-fragments 4 `
#     -o "%(uploader)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" `
#     --embed-thumbnail `
#     --convert-thumbnails jpg `
#     --embed-metadata `
#     "https://www.youtube.com/watch?v=dAqQqmaI9vY"

    