# Single folder version - all videos in the current directory will be compressed and saved with "_Compressed" appended to the filename.
for f in *.mp4; do
    # Skip files that already have "_Compressed" in the name to avoid double-processing
    if [[ "$f" != *"_Compressed"* ]]; then
        ffmpeg -i "$f" -c:v libx265 -crf 30 -preset slow -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    fi
done


# recursive version
find . -type f -name "*.mp4" ! -name "*_Compressed.mp4" -exec sh -c '
    for f do
        ffmpeg -i "$f" -c:v libx265 -crf 30 -preset slow -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    done
' sh {} +


# hardware accelerated version for macOS using the VideoToolbox framework
for f in *.mp4; do
    if [[ "$f" != *"_Compressed"* ]]; then
        ffmpeg -i "$f" -c:v hevc_videotoolbox -q:v 60 -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    fi
done

# recursive hardware accelerated version for macOS using the VideoToolbox framework
find . -type f -name "*.mp4" ! -name "*_Compressed.mp4" -exec sh -c '
    for f do
        ffmpeg -i "$f" -c:v hevc_videotoolbox -q:v 60 -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    done
' sh {} +