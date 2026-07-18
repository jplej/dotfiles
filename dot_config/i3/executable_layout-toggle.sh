#!/usr/bin/env bash
# Toggle keyboard layout us <-> ca. Bound to $mod+i.
# One layout at a time, not XKB groups: `setxkbmap -query` can only report the
# active layout when there is exactly one, which is what polybar reads.

if [[ "$(setxkbmap -query | awk '/^layout:/ {print $2}')" == "ca" ]]; then
    setxkbmap -layout us
else
    setxkbmap -layout ca
fi
