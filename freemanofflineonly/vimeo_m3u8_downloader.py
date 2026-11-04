import os
import yt_dlp
from dotenv import load_dotenv

# Load variables from the .env file in the same directory
load_dotenv()

def download_master_playlist(url: str, output_path: str, connections: int = 8) -> None:
    """
    Downloads a master m3u8 playlist, extracting the 240p video and best audio.
    """
    print(f"[*] Downloading {output_path} at 240p (Using {connections} connections)...")
    ydl_opts = {
        'outtmpl': output_path,
        'concurrent_fragment_downloads': connections,
        # Grabs best video up to 240p + best audio, or best combined format up to 240p
        'format': 'bestvideo[height<=240]+bestaudio/best[height<=240]',
        'merge_output_format': 'mp4', # Ensures the final container is MP4
        'quiet': False,
        'no_warnings': True,
    }
    
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

def main():
    # Fetch URL and config from the .env file
    PLAYLIST_URL = os.getenv("PLAYLIST_URL")
    FINAL_OUTPUT_NAME = os.getenv("FINAL_OUTPUT_NAME", "output.mp4")
    
    if not PLAYLIST_URL:
        print("[-] Error: PLAYLIST_URL is missing from the .env file.")
        return

    try:
        download_master_playlist(PLAYLIST_URL, FINAL_OUTPUT_NAME, connections=8)
        print(f"[+] Success! Final video saved as '{FINAL_OUTPUT_NAME}'")

    except Exception as e:
        print(f"[-] An error occurred during the process: {e}")

if __name__ == "__main__":
    main()
