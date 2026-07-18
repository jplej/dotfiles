#!/usr/bin/env bash
# Bluetooth. Shows the connected device, nothing when none.
# echo "" is required: polybar keeps the last value if a script prints nothing.

source "$(dirname "$0")/colors.sh"

device=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)

if [[ -n "$device" ]]; then
    printf '%%{F%s}%%{T2}󰂱%%{T-} %s%%{F-}\n' "$IDLE" "$device"
else
    echo ""
fi
