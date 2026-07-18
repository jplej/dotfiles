#!/usr/bin/env bash
# Sets a random wallpaper at login from the LOCAL cache (always available, no
# pCloud dependency). The cache is refreshed each session by wallpaper-sync.sh.
# To change the source, edit WALL_DIR below, then reload i3.

# ─── EDIT THIS LINE to change the folder ───────────────────────────────────
WALL_DIR="$HOME/.local/share/wallpapers/nature"
# Examples you can paste instead:
#   ~/.local/share/wallpapers          (everything, all subfolders)
#   ~/.local/share/wallpapers/pixel    ~/.local/share/wallpapers/abstract
# ───────────────────────────────────────────────────────────────────────────

img=$(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) 2>/dev/null | shuf -n1)
[ -n "$img" ] || { echo "wallpaper: nothing in $WALL_DIR (has the cache synced yet?)" >&2; exit 1; }
exec feh --no-fehbg --bg-fill "$img"
