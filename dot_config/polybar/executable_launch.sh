#!/usr/bin/env bash
# Kill BOTH polybar and the fullscreen-hide watcher. Killing only polybar
# leaks a watcher on every relaunch, and each one polls xprop twice a second.

killall -q polybar
pkill -f "$HOME/.config/polybar/fullscreen-hide.sh"
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done

# The X11 XEmbed tray can only live on one bar, so host it on the primary output only.
primary=$(polybar --list-monitors | awk -F: '/\(primary\)/{print $1}')

# One bar per connected output. pin-workspaces makes each bar show only its
# own screen's workspaces, so every monitor advertises what it's displaying.
for m in $(polybar --list-monitors | cut -d: -f1); do
  if [ "$m" = "$primary" ]; then bar=deskbar-primary; else bar=deskbar; fi
  MONITOR="$m" polybar "$bar" 2>&1 | tee -a "/tmp/polybar-deskbar-$m.log" &
done
"$HOME/.config/polybar/fullscreen-hide.sh" &

echo "polybar launched"
