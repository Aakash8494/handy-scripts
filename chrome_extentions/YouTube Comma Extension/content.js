// The 'true' at the end of this listener catches the key press BEFORE YouTube does
document.addEventListener('keydown', function (e) {
    // Check if Left arrow, Right arrow, or the 'c' key was pressed
    if (e.key === 'ArrowLeft' || e.key === 'ArrowRight' || e.key.toLowerCase() === 'c') {

        // Don't trigger if you are typing in the search bar or a comment
        const activeTag = document.activeElement.tagName.toLowerCase();
        if (activeTag === 'input' || activeTag === 'textarea' || document.activeElement.isContentEditable) {
            return;
        }

        const video = document.querySelector('video');
        if (!video) return;

        // Block YouTube's normal behavior (5s jump or Captions toggle)
        e.preventDefault();
        e.stopPropagation();

        if (e.key === 'ArrowLeft') {
            // Jump back 2.5 seconds (preventing it from going below 0)
            video.currentTime = Math.max(0, video.currentTime - 2.5);
        } else if (e.key === 'ArrowRight') {
            // Jump forward 2.5 seconds (preventing it from going past the video's total length)
            video.currentTime = Math.min(video.duration, video.currentTime + 2.5);
        } else if (e.key.toLowerCase() === 'c') {
            // Toggle speed: if it's currently 2x, revert to 1x; otherwise, set to 2x
            video.playbackRate = video.playbackRate === 2.0 ? 1.0 : 2.0;
        }
    }
}, true);