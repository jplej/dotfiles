#!/usr/bin/env bash
# Volume. Muted is a failure (you think it's playing, it isn't); loud and quiet are thresholds.
# tail = true in config.ini: pactl pushes events, so this runs once and streams.

source "$(dirname "$0")/colors.sh"

render() {
    local vol muted colour icon
    vol=$(pamixer --get-volume 2>/dev/null) || vol=0
    muted=$(pamixer --get-mute 2>/dev/null) || muted=false

    if [[ "$muted" == "true" ]]; then
        colour=$ERROR; icon='󰝟'
    elif (( vol >= 100 )); then
        colour=$WARN; icon='󰕾'
    elif (( vol <= 15 )); then
        colour=$WARN; icon='󰕿'
    else
        colour=$IDLE; icon='󰖀'
    fi

    printf '%%{F%s}%%{T2}%s%%{T-} %s%%%%{F-}\n' "$colour" "$icon" "$vol"
}

render
pactl subscribe 2>/dev/null | while read -r ev; do
    [[ "$ev" == *"on sink"* ]] && render
done
