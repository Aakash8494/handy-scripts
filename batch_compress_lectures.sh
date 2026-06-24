mkdir -p compressed
for f in *.mp4; do
  if [ ! -f "compressed/$f" ]; then
    printf '\e[36mCompressing: %s...\e[0m\n' "$f"
    ffmpeg -i "$f" -c:v libx265 -crf 28 -r 24 -preset fast -c:a aac -b:a 96k "compressed/$f"
    printf '\e[32mFinished: %s\e[0m\n\n' "$f"
  else
    printf '\e[90mSkipping: %s (Already compressed)\e[0m\n' "$f"
  fi
done
printf '\e[33mAll videos processed successfully!\e[0m\n'