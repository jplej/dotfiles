#!/usr/bin/env bash
# Event-driven workspace list: draws all 7 slots whether or not i3 has created them.
# i3 destroys empty workspaces, so internal/i3 can never show them — hence this module.
# Renders once at start, then only when i3 emits a workspace event (idle cost: zero).
set -u

# launch.sh exports MONITOR per bar; empty means "standalone run, show everything"
MONITOR=${MONITOR:-}

# Keep in sync with polybar/config.ini [colors]
WELL='#2E3440'; FACE='#3B4252'; LINE='#4C566A'; SHADOW='#2E3440'
TEXT='#ECEFF4'; IDLE='#616E88'; FOCUS='#88C0D0'; ERROR='#BF616A'

# Index -> icon, mirroring ws-icon-* in config.ini
declare -A ICON=([1]='●' [2]='●' [3]='●' [4]='󰖟' [5]='󰈙' [6]='󰇮' [7]='󰭹')

render() {
	local json n out='' state bg fg ol ul here
	declare -A live=() on=()
	json=$(i3-msg -t get_workspaces 2>/dev/null) || return
	# One jq pass: "num focused urgent output" per existing workspace
	while read -r num f u o; do
		on[$num]=$o
		if [ "$u" = true ]; then live[$num]=urgent
		elif [ "$f" = true ]; then live[$num]=focused
		else live[$num]=open; fi
	done < <(jq -r '.[] | "\(.num) \(.focused) \(.urgent) \(.output)"' <<<"$json")

	# Empty workspaces have no output (i3 destroys them and forgets), so they need a
	# home: the primary screen. Falls back to the focused output if no primary is set.
	here=$(i3-msg -t get_outputs 2>/dev/null | jq -r '.[] | select(.primary) | .name')
	[ -n "$here" ] || here=$(jq -r '.[] | select(.focused) | .output' <<<"$json")

	for n in 1 2 3 4 5 6 7; do
		state=${live[$n]:-empty}
		# Live workspaces show on their real output; empty ones follow focus
		if [ "$state" = empty ]; then
			[ "$MONITOR" = "$here" ] || continue
		else
			[ "${on[$n]}" = "$MONITOR" ] || continue
		fi
		case $state in
			# Focused mirrors label-focused; empty is the new state internal/i3 can't express
			focused) bg=$WELL;  fg=$FOCUS; ol=$SHADOW; ul=$LINE ;;
			urgent)  bg=$ERROR; fg=$TEXT;  ol=$LINE;   ul=$SHADOW ;;
			open)    bg=$FACE;  fg=$TEXT;  ol=$LINE;   ul=$SHADOW ;;
			empty)   bg=$WELL;  fg=$IDLE;  ol=$LINE;   ul=$SHADOW ;;
		esac
		# Clicking an empty slot switches there, which is what makes i3 create it
		out+="%{A1:i3-msg -q workspace number $n:}"
		out+="%{B${bg}}%{F${fg}}%{o${ol}}%{u${ul}}%{+o}%{+u}"
		out+="   $n %{T2}${ICON[$n]}%{T-}   "
		out+="%{-o}%{-u}%{B-}%{F-}%{A}"
	done
	echo "$out"
}

render
# -m keeps the subscription open, streaming one JSON line per workspace event
i3-msg -t subscribe -m '["workspace"]' | while read -r _; do render; done
