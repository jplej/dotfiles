#!/usr/bin/env bash
# Single lock entry point: blurred desktop + padlock, with unlock ring for keypress feedback.
img="$(mktemp --suffix=.png)"
trap 'rm -f "$img"' EXIT
~/.config/i3/bin/sound.sh lock

# Lid closed (docked): screen off immediately, skip the usual idle grace period
grep -q closed /proc/acpi/button/lid/*/state 2>/dev/null && xset dpms force off
if { scrot --overwrite "$img" 2>/dev/null || import -window root "$img" 2>/dev/null; } \
   && convert "$img" -resize 25% -blur 0x2 -resize 400% \
        /usr/share/i3lock-fancy/lock.png -gravity center -composite "$img" 2>/dev/null; then
    i3lock -n -i "$img"
else
    i3lock -n -c 2e3440
fi

# i3lock -n blocks until unlock, so this lands on the way out
~/.config/i3/bin/sound.sh unlock
