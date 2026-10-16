#!/usr/bin/env bash
# Single sound dispatcher: every event name maps to one file here, so retuning is one edit
S="$HOME/.local/share/sounds/mac"
F="/usr/share/sounds/freedesktop/stereo"

case "$1" in
    login)      f="$S/submarine.wav" ;;
    logout)     f="$S/funk.wav" ;;
    lock)       f="$S/purr.wav" ;;
    unlock)     f="$S/bottle.wav" ;;
    volume)     f="$F/audio-volume-change.oga" ;;
    screenshot) f="$F/camera-shutter.oga" ;;
    info)       f="$S/bottle.wav" ;;
    warning)    f="$S/basso.wav" ;;
    error)      f="$S/sosumi.wav" ;;
    done)       f="$S/glass.wav" ;;
    battery)    f="$F/dialog-warning.oga" ;;
    *)          echo "unknown event: $1" >&2; exit 1 ;;
esac

[ -r "$f" ] || { echo "missing sound: $f" >&2; exit 1; }
exec paplay "$f"
