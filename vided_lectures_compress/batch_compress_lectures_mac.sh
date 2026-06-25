# recursive hardware accelerated version for macOS using the VideoToolbox framework
find . -type f -name "*.mp4" ! -name "*_Compressed.mp4" -exec sh -c '
    for f do
        ffmpeg -i "$f" -c:v hevc_videotoolbox -q:v 60 -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    done
' sh {} +