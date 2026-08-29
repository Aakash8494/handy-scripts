find . -type f \( -iname "*.mp4" -o -iname "*.mkv" \) ! -path "./Compressed/*" -print0 | sort -z -t '/' -k 2n | xargs -0 -P 3 -I {} sh -c '
    # Extract the directory and filename
    dir=$(dirname "$1")
    base=$(basename "$1")
    
    # Define the target output path
    output="Compressed/$dir/${base%.*}_Compressed.mp4"
    
    # Check if the output file already exists; if so, skip.
    if [ -f "$output" ]; then
        echo "Skipping (already exists): $output"
        exit 0
    fi
    
    # Create the matching folder structure inside "Compressed"
    mkdir -p "Compressed/$dir"
    
    # Run FFmpeg (Quiet errors, but show stats)
    ffmpeg -nostdin -y -loglevel error -stats -i "$1" \
        -c:v hevc_videotoolbox -q:v 50 \
        -vf "scale=-2:'\''min(480,ih)'\''" \
        -r 15 \
        -tag:v hvc1 \
        -c:a aac -b:a 64k -ac 1 \
        "$output"
' _ {}