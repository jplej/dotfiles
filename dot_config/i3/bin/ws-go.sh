#!/usr/bin/env bash
# Workspace = its apps: switching to an empty one launches what belongs there.
# One table below owns the mapping; keybindings and the GO mode both route through here.
n="$1"
[ -n "$n" ] || { echo "usage: ws-go.sh <1-7>" >&2; exit 1; }

i3-msg workspace number "$n" >/dev/null

# Only populate a workspace that is actually empty, so re-entering never duplicates
if i3-msg -t get_tree | python3 -c "
import json,sys
t=json.load(sys.stdin)
target=sys.argv[1]
found=[]
def walk(n, ws=None):
    if n.get('type')=='workspace': ws=n['name']
    if n.get('window') and ws==target: found.append(1)
    for c in n.get('nodes',[])+n.get('floating_nodes',[]): walk(c, ws)
walk(t)
sys.exit(0 if found else 1)
" "$n"; then
    exit 0
fi

case "$n" in
    1|2|3) exec ~/.config/i3/bin/ws-code.sh "$n" ;;
    4)     exec flatpak run com.brave.Browser ;;
    5)     exec zettlr ;;
    6)     exec flatpak run eu.betterbird.Betterbird ;;
    7)     exec flatpak run org.telegram.desktop ;;
esac
