# 1. Map of the complete, correct titles
$titles = @{
    "Day 1"  = "How to receive new information"
    "Day 2"  = "Why you need to be more productive urgently"
    "Day 3"  = "Going beyond most productivity advice"
    "Day 4"  = "The Root of all distraction"
    "Day 5"  = "How to make conscious choices"
    "Day 6"  = "How to Prioritize Tasks & Achieve More with Less Effort"
    "Day 7"  = "Become unavailable"
    "Day 8"  = "How to make your work feel like play"
    "Day 9"  = "Why your motivation always wears off (and how to sustain it)"
    "Day 10" = "How to maintain a positive emotional state"
    "Day 11" = "Full Guide On Building Your Productivity System"
    "Day 12" = "Productivity strategy 1"
    "Day 13" = "Productive Reading - How to get the maximum out of a book"
    "Day 14" = "Optimize Productivity with Sleep - Dr. Arpit Mehra"
    "Day 15" = "Optimize Productivity with Breathwork - Himanshu Sharma"
    "Day 16" = "Get rid of perfectionism"
    "Day 17" = "Kill the root cause of your mobile addiction"
    "Day 18" = "How to enter a flow state on command"
    "Day 19" = "Why you thrive in chaos & solution to such negative patterns"
    "Day 20" = "Summing it all up"
    "Day 21" = "Q-A"
}

# 2. Get all files in the current directory
$files = Get-ChildItem -File

# 3. Loop through each file and fix the name
foreach ($file in $files) {
    # Skip the script file itself
    if ($file.Extension -eq ".ps1") {
        continue
    }

    $baseName = $file.BaseName
    $extension = $file.Extension
    
    # Use Regex to extract just the "Day X" part from the start of the current filename
    # E.g., turns "Day 1 - Course Introduction" into just "Day 1"
    if ($baseName -match "^(Day \d+)") {
        $dayPart = $matches[1]
        
        # Check if we have a title mapped for this extracted day
        if ($titles.ContainsKey($dayPart)) {
            $titleToAppend = $titles[$dayPart]
            
            # Create the completely new filename format, overriding the old bad title
            $newName = "$dayPart - $titleToAppend$extension"
            
            # Only rename if the new name is actually different (prevents errors on already fixed files)
            if ($file.Name -ne $newName) {
                try {
                    Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
                    Write-Host "Fixed: '$($file.Name)' -> '$newName'" -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed to rename '$($file.Name)': $_" -ForegroundColor Red
                }
            }
        }
    }
}

Write-Host "Correction complete!" -ForegroundColor Cyan