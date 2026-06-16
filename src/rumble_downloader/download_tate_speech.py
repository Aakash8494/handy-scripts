import yt_dlp

# 1. Upgraded Filter Logic
def check_title_filter(info, *, incomplete):
    # Let playlists/channels pass through so they can be scanned
    if info.get('_type') == 'playlist':
        return None
        
    # Safely try to grab the title
    title = info.get('title')
    
    # If yt-dlp couldn't read the title from the thumbnail grid, 
    # let it pass so it can open the actual video page and check.
    if not title:
        if incomplete:
            return None
        else:
            return 'Skipping: Completely missing title data'
            
    # Check for our keyword
    if 'emergency' not in title.lower():
        return f'Skipping: "{title}" does not contain EMERGENCY MEETING'
        
    return None

# 2. Set up the yt-dlp options
ydl_opts = {
    'paths': {'home': r'C:\Users\aakas\Downloads'},
    'format': 'hls-675',
    'outtmpl': {'default': '%(uploader)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s'},
    'download_archive': 'tatespeecharchive.txt',
    
    'match_filter': check_title_filter,
    'ignoreerrors': True,
    'writethumbnail': True,
    
    'postprocessors': [
        {'key': 'FFmpegThumbnailsConvertor', 'format': 'jpg'},
        {'key': 'FFmpegMetadata', 'add_metadata': True},
    ],
}

# 3. The Magic Fix: We hit the sub-tabs directly instead of the main page!
urls = [
    "https://rumble.com/c/TateSpeech/videos",
    "https://rumble.com/c/TateSpeech/livestreams"
]

print("Starting scan of Rumble Video and Livestream tabs...")
with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    ydl.download(urls)
print("Finished!")