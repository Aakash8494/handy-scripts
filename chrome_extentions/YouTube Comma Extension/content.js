// The 'true' at the end of this listener catches the key press BEFORE YouTube does
document.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowLeft') {

        // Don't trigger if you are typing in the search bar or a comment
        const activeTag = document.activeElement.tagName.toLowerCase();
        if (activeTag === 'input' || activeTag === 'textarea' || document.activeElement.isContentEditable) {
            return;
        }

        const video = document.querySelector('video');
        if (!video) return;

        // Block YouTube's normal 5-second jump
        e.preventDefault();
        e.stopPropagation();

        // Jump back exactly 2.5 seconds (preventing it from going below 0)
        video.currentTime = Math.max(0, video.currentTime - 2.5);
    }
}, true);