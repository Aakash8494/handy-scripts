# recursive hardware accelerated version for macOS using the VideoToolbox framework
find . -type f -name "*.mp4" ! -name "*_Compressed.mp4" -exec sh -c '
    for f do
        ffmpeg -i "$f" -c:v hevc_videotoolbox -q:v 60 -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
    done
' sh {} +


# The (N) flag tells Zsh to silently ignore the file type if none exist in the folder,
# preventing the "no matches found" error.
for f in *.mp4(N) *.mkv(N) *.mov(N) *.avi(N); do
    
    # Skip files that already have "_Compressed" in the name
    if [[ "$f" != *"_Compressed"* ]]; then
        
        # ${f%.*} strips the original extension (like .mkv) 
        # We then append _Compressed.mp4 to force the MP4 container
        ffmpeg -i "$f" -c:v libx265 -crf 30 -preset slow -r 15 -c:a aac -b:a 64k -ac 1 "${f%.*}_Compressed.mp4"
        
    fi
done