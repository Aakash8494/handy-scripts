find . -type f \( -iname "*.mp4" -o -iname "*.mkv" \) ! -iname "*_Compressed.*" -print0 | xargs -0 -P 3 -I {} sh -c '
    ffmpeg -nostdin -y -i "$1" \
        -c:v hevc_videotoolbox -q:v 50 \
        -vf "scale=-2:'\''min(480,ih)'\''" \
        -r 15 \
        -tag:v hvc1 \
        -c:a aac -b:a 64k -ac 1 \
        "${1%.*}_Compressed.mp4"
' _ {}