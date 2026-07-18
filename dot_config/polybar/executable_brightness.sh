#!/usr/bin/env bash
# Brightness. Always visible, like volume — it used to flash for 3s after a change and hide,
# which meant it was invisible unless you happened to be pressing the key.
# tail = true in config.ini: udev pushes backlight events, so this runs once and streams.

source "$(dirname "$0")/colors.sh"

BL=/sys/class/backlight/intel_backlight

render() {
    local cur max pct icon
    cur=$(< "$BL/brightness") || return
    max=$(< "$BL/max_brightness") || return
    (( max > 0 )) || return
    pct=$(( cur * 100 / max ))

    if   (( pct < 34 )); then icon='󰃞'
    elif (( pct < 67 )); then icon='󰃟'
    else                      icon='󰃠'
    fi

    printf '%%{F%s}%%{T2}%s%%{T-} %s%%%%{F-}\n' "$IDLE" "$icon" "$pct"
}

render
trap 'pkill -P $$ 2>/dev/null' EXIT TERM INT
udevadm monitor --udev --subsystem-match=backlight 2>/dev/null | while read -r line; do
    [[ "$line" == *change* ]] && render
done
