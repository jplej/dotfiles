#!/usr/bin/env bash
# Warn once per discharge below 15%; rearms only after charging back above 20%
SOUND="$HOME/.config/i3/bin/sound.sh"
warned=0

while true; do
    cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    if [ -n "$cap" ]; then
        if [ "$status" = "Discharging" ] && [ "$cap" -le 15 ] && [ "$warned" -eq 0 ]; then
            notify-send -a battery -u critical "Battery low" "${cap}% remaining"
            "$SOUND" battery
            warned=1
        elif [ "$cap" -ge 20 ]; then
            warned=0
        fi
    fi
    sleep 60
done
