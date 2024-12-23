#!/bin/bash
[ -z "$DISPLAY" ] && DISPLAY=:0
export DISPLAY

# Get our location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Clear Chromium config and cache, they tend to corrupt themselves, causing Chromium to segfault
if [ -z "$RUNNING_IN_DOCKER" ]; then
    rm -rf "$HOME/.config/chrome"
    rm -rf "$HOME/.cache/chrome"
fi

# Autohide mouse when inactive
unclutter &

# Give pi account a complex random password
if [ -z "$RUNNING_IN_DOCKER" ] && [ -e "/boot/autosecure" ]
then
    NEWPW="$(openssl rand -base64 32 | tr -d 'EOF')"
    passwd <<EOF
    raspberry
    $NEWPW
    $NEWPW
EOF
fi

# Start Python-based controller to ensure reloads on load failures
if [ -n "$RUNNING_IN_DOCKER" ]; then
    python3 "$DIR/chromium_controller.py" "$(head -n 1 /config/mutesound.txt)" &
else
    python3 "$DIR/chromium_controller.py" "$(head -n 1 /boot/mutesound.txt)" &
fi

BROWSER="$(command -v google-chrome)"
[ -z "$BROWSER" ] && BROWSER="$(command -v chromium)"


# Start Chromium
if [ -n "$RUNNING_IN_DOCKER" ]; then
    $BROWSER --no-sandbox --kiosk --touch-events=enabled --disable-pinch --noerrdialogs --disable-session-crashed-bubble --start-fullscreen --remote-debugging-port=9222 --app="file:///config/placeholder.html"
else
    while true; do
        $BROWSER --no-sandbox --kiosk --touch-events=enabled --disable-pinch --noerrdialogs --disable-session-crashed-bubble --start-fullscreen --remote-debugging-port=9222 --app="file:///boot/placeholder.html"
    done
fi
