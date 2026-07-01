find . -type f \( -iname "*.mp4" -o -iname "*.mkv" \) ! -iname "*_Compressed.*" -exec sh -c '
    for f do
        ffmpeg -i "$f" -c:v hevc_videotoolbox -q:v 60 -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    done
' sh {} +