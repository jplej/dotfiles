#!/usr/bin/env bash
# Hide polybar when the active window is fullscreen.

set -u

is_fullscreen() {
    local ids id cur wd
    cur=$(xprop -root _NET_CURRENT_DESKTOP 2>/dev/null | awk '{print $NF}')
    ids=$(xprop -root _NET_CLIENT_LIST 2>/dev/null | grep -oE '0x[0-9a-f]+')
    for id in $ids; do
        xprop -id "$id" _NET_WM_STATE 2>/dev/null | grep -q _NET_WM_STATE_FULLSCREEN || continue
        wd=$(xprop -id "$id" _NET_WM_DESKTOP 2>/dev/null | awk '{print $NF}')
        [[ "$wd" == "$cur" || "$wd" == "0xffffffff" ]] || continue
        return 0
    done
    return 1
}

apply() {
    local action=$1
    polybar-msg cmd "$action" >/dev/null 2>&1
}

state=shown
check() {
    if is_fullscreen; then
        if [[ $state != hidden ]]; then apply hide; state=hidden; fi
    else
        if [[ $state != shown ]]; then apply show; state=shown; fi
    fi
}

while true; do
    check
    sleep 0.5
done
