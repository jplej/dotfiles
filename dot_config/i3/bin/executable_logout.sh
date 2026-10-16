#!/usr/bin/env bash
# paplay is synchronous, so the chime finishes before i3 tears the session down
~/.config/i3/bin/sound.sh logout
exec i3-msg exit
