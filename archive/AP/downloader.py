import os
import sys
import argparse
from archive.AP.ap_core import (
    parse_url_parts,
    ensure_dir,
    download_with_ffmpeg,
    run_in_parallel,
)

OUTPUT_ROOT = "output_videos"

def download_item(item_data, folder_override=None):
    """
    Handles the direct download of a single video item.
    """
    url, custom_name = item_data
    parsed_folder, parsed_name = parse_url_parts(url)
    
    folder_name = folder_override if folder_override else parsed_folder
    video_name = custom_name if custom_name else parsed_name

    final_folder = os.path.join(OUTPUT_ROOT, folder_name)
    ensure_dir(final_folder)

    mp4_path = os.path.join(final_folder, f"{video_name}.mp4")
    
    print(f"--- Downloading: {video_name} ---")
    if os.path.exists(mp4_path):
        print(f"    [Skip] Already exists: {mp4_path}")
    else:
        # Direct download via ffmpeg
        if not download_with_ffmpeg(url, mp4_path):
            print(f"    [Error] Failed to download: {url}")

def main():
    parser = argparse.ArgumentParser(description="High-Speed AP Video Downloader")
    
    parser.add_argument("--url", action="append", help="Format: 'URL' or 'URL|filename'")
    parser.add_argument("--file", help="Text file with one 'URL|filename' per line")
    parser.add_argument("--folder", help="Target subfolder name")
    parser.add_argument("--workers", type=int, default=4, help="Number of parallel downloads (default: 4)")

    args = parser.parse_args()

    # Pre-check for folder existence to avoid redundant work
    if args.folder:
        target_path = os.path.join(OUTPUT_ROOT, args.folder)
        if os.path.exists(target_path):
            print(f"Aborting: Folder '{args.folder}' already exists.")
            sys.exit(0) 

    # Collect tasks
    raw_inputs = []
    if args.url:
        raw_inputs.extend(args.url)
    if args.file:
        try:
            with open(args.file, "r", encoding="utf-8") as f:
                raw_inputs.extend([line.strip() for line in f if line.strip()])
        except FileNotFoundError:
            print(f"Error: File '{args.file}' not found.")
            return

    if not raw_inputs:
        print("No URLs provided.")
        return

    # De-duplicate URLs
    tasks = []
    seen_urls = set()
    for entry in raw_inputs:
        url, name = entry.split("|", 1) if "|" in entry else (entry, None)
        if url not in seen_urls:
            tasks.append((url, name))
            seen_urls.add(url)

    # Execute parallel downloads
    run_in_parallel(
        lambda t: download_item(t, folder_override=args.folder),
        tasks,
        max_workers=args.workers,
    )

    print(f"\n🎯 Downloads Complete! Location: {OUTPUT_ROOT}")

if __name__ == "__main__":
    main()