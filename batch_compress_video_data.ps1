ffprobe -hide_banner -i "your_lecture_video.mp4"

ffmpeg -i "Phase 3.mp4" -c:v libx265 -crf 30 -preset slow -r 15 -c:a aac -b:a 64k -ac 1 "Phase_3_Compressed.mp4"