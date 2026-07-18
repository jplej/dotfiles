#!/usr/bin/env bash
# Mirrors the pCloud wallpaper collection into the local cache, in the background.
# Runs once per login; new wallpapers added on pCloud are picked up next boot.

SRC="$HOME/pCloudDrive/files/media/images/wallpapers"
DST="$HOME/.local/share/wallpapers"

# Give pCloud ~30s to mount after login, then try once. No connection? Just skip.
sleep 30

# Guard: never mirror from an empty/unmounted source, or --delete would wipe the copy.
[ -n "$(ls -A "$SRC" 2>/dev/null)" ] || { echo "wallpaper-sync: pCloud not available, skipping" >&2; exit 0; }

mkdir -p "$DST"
rsync -a --delete "$SRC/" "$DST/"
