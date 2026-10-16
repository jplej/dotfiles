#!/usr/bin/env bash
# Resets the X idle timer while a real window (not just a workspace) is fullscreen,
# so xss-lock won't fire mid-video regardless of whether the app inhibits the screensaver itself.
while true; do
    if i3-msg -t get_tree 2>/dev/null \
        | jq -e '.. | objects | select(.type=="con" or .type=="floating_con") | select(.fullscreen_mode==1) | select(.window!=null)' \
        >/dev/null 2>&1; then
        xset s reset
    fi
    sleep 30
done
