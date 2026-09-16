// --- 1. Toggleable Progress Bar CSS ---
const style = document.createElement('style');
style.textContent = `
    body.show-persistent-progress .html5-video-player.ytp-autohide .ytp-chrome-bottom {
        opacity: 1 !important;
    }
`;
document.head.appendChild(style);

// --- 2. Custom Keybinds ---
document.addEventListener('keydown', function (e) {
    // Guard: Don't trigger if typing in search bar, comments, or any text field
    const activeElement = document.activeElement;
    if (activeElement && (activeElement.tagName.toLowerCase() === 'input' ||
        activeElement.tagName.toLowerCase() === 'textarea' ||
        activeElement.isContentEditable)) {
        return;
    }

    // List of keys we want to override (Added z, x, v for playback speeds)
    const activeKeys = [
        'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown',
        'z', 'Z', 'x', 'X', 'c', 'C', 'v', 'V',
        ' ', 'p', 'P'
    ];

    if (!activeKeys.includes(e.key)) return;

    const video = document.querySelector('video');
    if (!video) return;

    // Block YouTube's normal behavior for our specific keys
    e.preventDefault();
    e.stopPropagation();

    // Configuration settings
    const SEEK_STEP = 2.5;
    const VOLUME_STEP = 0.05;

    // Execute actions based on the key pressed
    switch (e.key) {
        case 'ArrowLeft':
            video.currentTime = Math.max(0, video.currentTime - SEEK_STEP);
            break;
        case 'ArrowRight':
            video.currentTime = Math.min(video.duration, video.currentTime + SEEK_STEP);
            break;
        case 'ArrowUp':
            video.volume = Math.min(1.0, video.volume + VOLUME_STEP);
            break;
        case 'ArrowDown':
            video.volume = Math.max(0.0, video.volume - VOLUME_STEP);
            break;

        // --- Playback Speed Controls ---
        case 'z': case 'Z':
            video.playbackRate = 1.0;
            break;
        case 'x': case 'X':
            video.playbackRate = 1.25;
            break;
        case 'c': case 'C':
            video.playbackRate = 1.5;
            break;
        case 'v': case 'V':
            video.playbackRate = 2.0;
            break;

        // --- Toggles ---
        case 'p': case 'P':
            document.body.classList.toggle('show-persistent-progress');
            break;

        case ' ': // Restoring spacebar functionality since default was prevented
            if (video.paused) {
                video.play();
            } else {
                video.pause();
            }
            break;
    }
}, true);
