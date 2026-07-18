#!/usr/bin/env bash
# Camera. Active means the lens is live -- something is watching through it.
# No event source exists (no pactl equivalent), so poll the sensor's runtime PM.
# echo "" is required: polybar keeps the last value if a script prints nothing.

source "$(dirname "$0")/colors.sh"

status=$(cat /sys/bus/i2c/drivers/ov01a10/*/power/runtime_status 2>/dev/null)

if [[ "$status" == "active" ]]; then
    printf '%%{F%s}%%{T2}󰄀%%{T-} CAM%%{F-}\n' "$WARN"
else
    echo ""
fi
