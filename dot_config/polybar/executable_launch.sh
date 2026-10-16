#!/usr/bin/env bash
# Kill BOTH polybar and the fullscreen-hide watcher. Killing only polybar
# leaks a watcher on every relaunch, and each one polls xprop twice a second.

# i3 (exec_always) and autorandr's postswitch both call this, and hotplug fires it
# again — overlapping runs interleave kill and spawn, orphaning a bar per race.
exec 9>"/tmp/polybar-launch-$UID.lock"
flock 9

killall -q polybar
pkill -f "$HOME/.config/polybar/fullscreen-hide.sh"
# Match by name, not -u $UID: under the udev path this runs as root and $UID is 0,
# so the old check saw none of the user's bars and never actually waited.
while pgrep -x polybar >/dev/null; do sleep 0.2; done

# The X11 XEmbed tray can only live on one bar, so host it on the primary output only.
primary=$(polybar --list-monitors | awk -F: '/\(primary\)/{print $1}')

# One bar per connected output. pin-workspaces makes each bar show only its
# own screen's workspaces, so every monitor advertises what it's displaying.
for m in $(polybar --list-monitors | cut -d: -f1); do
  if [ "$m" = "$primary" ]; then bar=deskbar-primary; else bar=deskbar; fi
  # Whole pipeline in a subshell with fd 9 closed. Long-lived children (and the
  # module scripts polybar spawns) would otherwise inherit the lock fd and hold
  # it open after this script exits, deadlocking every later run.
  ( MONITOR="$m" polybar "$bar" 2>&1 | tee -a "/tmp/polybar-deskbar-$m.log" ) 9>&- &
done
( "$HOME/.config/polybar/fullscreen-hide.sh" ) 9>&- &

echo "polybar launched"
