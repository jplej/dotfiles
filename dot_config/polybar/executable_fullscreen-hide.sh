#!/usr/bin/env bash
# Hide polybar when the active window is fullscreen.
# Event-driven: i3 pushes window/workspace events, so this only looks when something moved.
# It used to poll xprop twice a second — two -root calls plus one -id per window, forever.

set -u

# The focused workspace is the one holding the focused container; an empty workspace is
# focused itself. Hide only when something on THAT workspace is fullscreen.
is_fullscreen() {
    i3-msg -t get_tree 2>/dev/null | jq -e '
        [ .. | objects | select(.type? == "workspace") ]
        | map(select([.. | objects | select(.focused? == true)] | length > 0))
        | map(select([.. | objects | select((.fullscreen_mode? // 0) > 0 and .window? != null)] | length > 0))
        | length > 0
    ' >/dev/null 2>&1
}

state=
check() {
    local want
    if is_fullscreen; then want=hidden; else want=shown; fi
    [[ "$want" == "$state" ]] && return
    state=$want
    [[ "$want" == hidden ]] && polybar-msg cmd hide >/dev/null 2>&1 \
                            || polybar-msg cmd show >/dev/null 2>&1
}

check
# launch.sh pkills this script by name, which does not match the i3-msg child — without this
# trap the subscriber is orphaned until an event happens to break its pipe.
trap 'pkill -P $$ 2>/dev/null' EXIT TERM INT
# -m streams events; each line is one change, and any of them can alter fullscreen state.
i3-msg -t subscribe -m '["window","workspace"]' 2>/dev/null | while read -r _; do
    check
done
