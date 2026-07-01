find . -type f \( -iname "*.mp4" -o -iname "*.mkv" \) ! -path "./Compressed/*" -print0 | xargs -0 -P 3 -I {} sh -c '
    # Extract the directory and filename
    dir=$(dirname "$1")
    base=$(basename "$1")
    
    # Create the matching folder structure inside "Compressed"
    mkdir -p "Compressed/$dir"
    
    # Run FFmpeg and save the output into the new folder
    ffmpeg -nostdin -y -i "$1" \
        -c:v hevc_videotoolbox -q:v 50 \
        -vf "scale=-2:'\''min(480,ih)'\''" \
        -r 15 \
        -tag:v hvc1 \
        -c:a aac -b:a 64k -ac 1 \
        "Compressed/$dir/${base%.*}_Compressed.mp4"
' _ {}