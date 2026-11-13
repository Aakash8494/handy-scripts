import os
import time

import yt_dlp
from dotenv import load_dotenv
from yt_dlp.utils import DownloadError

load_dotenv()


def download_master_playlist(
    url: str,
    output_path: str,
    connections: int = 16,  # Increased default connections for much faster speeds
    attempts: int = 3,
) -> None:
    """Download a playlist at up to 240p, retrying failed fragments and attempts."""

    ydl_opts = {
        "outtmpl": output_path,
        "format": "bestvideo[height<=240]+bestaudio/best[height<=240]",
        "merge_output_format": "mp4",

        # 1. Native parallel fragment downloads (for HLS/DASH streams)
        "concurrent_fragment_downloads": connections,

        # 2. External downloader integration (for standard streams)
        "external_downloader": "aria2c",
        "external_downloader_args": {
            "aria2c": [
                "-c",             # Continue downloading partially downloaded files
                "-j", str(connections), # Max concurrent downloads
                "-x", str(connections), # Max connections per server
                "-s", str(connections), # Max connections per file
                "-k", "1M",       # Split size
            ]
        },

        # 3. Client spoofing (helps bypass YouTube's specific bandwidth throttling)
        "extractor_args": {
            "youtube": ["player_client=android", "player_client=web"]
        },

        # Retry network requests, fragments, and extraction.
        "retries": 10,
        "fragment_retries": 20,
        "extractor_retries": 5,
        "socket_timeout": 30,

        # Fail clearly if fragments remain unavailable after retries.
        "abort_on_unavailable_fragments": True,

        "quiet": False,
        "no_warnings": False,
    }

    for attempt in range(1, attempts + 1):
        print(f"[*] Download attempt {attempt}/{attempts}: {output_path}")

        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
            return
        except DownloadError as exc:
            if attempt == attempts:
                raise

            delay = min(10 * attempt, 30)
            print(f"[-] Download failed: {exc}")
            print(f"[*] Retrying in {delay} seconds...")
            time.sleep(delay)


def main() -> None:
    playlist_url = os.getenv("PLAYLIST_URL")
    output_name = os.getenv("FINAL_OUTPUT_NAME", "output.mp4")

    if not playlist_url:
        raise SystemExit("PLAYLIST_URL is missing from the .env file.")

    try:
        download_master_playlist(
            playlist_url,
            output_name,
            connections=16, # Pass the higher connection count here
            attempts=3,
        )
        print(f"[+] Download finished: {output_name}")
    except DownloadError as exc:
        raise SystemExit(f"[-] Download failed after retries: {exc}") from exc


if __name__ == "__main__":
    main()
