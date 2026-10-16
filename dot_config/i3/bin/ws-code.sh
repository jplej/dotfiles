#!/usr/bin/env bash
# Build a code workspace: helix left, coding agent right, both swallowed into the saved layout
n="$1"

i3-msg "workspace number $n; append_layout ~/.config/i3/layouts/code.json" >/dev/null

# Instance names are what the layout swallows on, so each terminal lands in its own slot
(setsid ghostty --x11-instance-name=helix -e hx >/dev/null 2>&1 &)
(setsid ghostty --x11-instance-name=agent -e claude >/dev/null 2>&1 &)
