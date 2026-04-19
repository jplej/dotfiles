#!/usr/bin/env bash

# kill running instances
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# launch bars
polybar status 2>&1 | tee -a /tmp/polybar-status.log &
polybar tray 2>&1 | tee -a /tmp/polybar-tray.log &

~/.config/polybar/fullscreen-hide.sh &

echo "polybar launched"
