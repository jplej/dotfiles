#!/usr/bin/env bash
# Mic. Muted is a failure (talking into a dead mic); capturing is a threshold you should know about.
# echo "" is required: polybar keeps the last value if a script prints nothing.
# tail = true in config.ini: pactl pushes events, so this runs once and streams.

source "$(dirname "$0")/colors.sh"

render() {
    local muted streams
    muted=$(pamixer --default-source --get-mute 2>/dev/null) || muted=false
    streams=$(pactl list short source-outputs 2>/dev/null | wc -l)

    if [[ "$muted" == "true" ]]; then
        printf '%%{F%s}%%{T2}󰍭%%{T-} MUTE%%{F-}\n' "$ERROR"
    elif (( streams > 0 )); then
        printf '%%{F%s}%%{T2}󰍬%%{T-} MIC%%{F-}\n' "$WARN"
    else
        echo ""
    fi
}

render
pactl subscribe 2>/dev/null | while read -r ev; do
    case "$ev" in
        *"on source"*|*"on server"*) render ;;
    esac
done
