# Set this to the name of the video file you downloaded
$inputFile = "your_downloaded_video.mp4" 

# List of clips mapped directly to the video's timeline.
# Start and End times are continuous to ensure no footage or transition time is lost.
$clips = @(
    @{ Start = "00:00:00"; End = "00:01:06"; Title = "01_Intro_and_Setup" }
    @{ Start = "00:01:06"; End = "00:05:14"; Title = "02_Warmup" }
    @{ Start = "00:05:14"; End = "00:06:56"; Title = "03_Surya_Namaskara" }
    
    # --- Split Asanas ---
    @{ Start = "00:06:56"; End = "00:07:05"; Title = "04_Asana_Intro" }
    @{ Start = "00:07:05"; End = "00:07:53"; Title = "05_Pawanmuktasana" }
    @{ Start = "00:07:53"; End = "00:08:41"; Title = "06_Markatasana" }
    @{ Start = "00:08:41"; End = "00:09:28"; Title = "07_Naukasana" }
    @{ Start = "00:09:28"; End = "00:10:21"; Title = "08_Sarvangasana" }
    @{ Start = "00:10:21"; End = "00:11:20"; Title = "09_Baddha_Konasana" }
    @{ Start = "00:11:20"; End = "00:12:14"; Title = "10_Mandukasana" }
    # --------------------
    
    @{ Start = "00:12:14"; End = "00:13:25"; Title = "11_Om_Chanting" }
    @{ Start = "00:13:25"; End = "00:14:42"; Title = "12_Bhastrika" }
    @{ Start = "00:14:42"; End = "00:19:03"; Title = "13_Kapalbhati" }
    @{ Start = "00:19:03"; End = "00:20:12"; Title = "14_Agnisar" }
    @{ Start = "00:20:12"; End = "00:21:23"; Title = "15_Jalandhara_Bandha" }
    @{ Start = "00:21:23"; End = "00:22:39"; Title = "16_Shitali_Kriya" }
    @{ Start = "00:22:39"; End = "00:26:49"; Title = "17_Anulom_Vilom" }
    @{ Start = "00:26:49"; End = "00:28:15"; Title = "18_Bhramari" }
    @{ Start = "00:28:15"; End = "00:30:59"; Title = "19_Shavasana_and_Outro" }
)

# Verify the input file exists before running
if (-Not (Test-Path $inputFile)) {
    Write-Host "Error: Cannot find $inputFile. Please update the file name in the script." -ForegroundColor Red
    exit
}

Write-Host "Starting video split..." -ForegroundColor Green

foreach ($clip in $clips) {
    $outputFile = "$($clip.Title).mp4"
    Write-Host "Extracting: $outputFile ($($clip.Start) to $($clip.End))" -ForegroundColor Cyan
    
    # Using -c copy for fast, lossless splitting without re-encoding
    ffmpeg -i $inputFile -ss $($clip.Start) -to $($clip.End) -c copy $outputFile -loglevel warning
}

Write-Host "All clips have been extracted successfully!" -ForegroundColor Green