#!/bin/bash

# Forked from https://github.com/davatorium/rofi-scripts/blob/5dfdb5f39b17544f23043b67d0fba63debdddab8/move_window_to_current
# which was originally by cornerman (https://github.com/cornerman).

# Requires: wmctrl

_dotfiles_scripts="${HOME}/.dotfiles/share"
_rofi="${_dotfiles_scripts}/rofi.sh"

declare -i index=0
while read -r window; do
    pid=$(echo "$window" | awk '{print $3}')
    program=$(ps -p "$pid" -o comm=)
    IDS[$index]=$(echo "$window" | awk '{print $1}')
    TITLES[$index]="$program: $(echo "$window" | awk '{for (i=5; i<=NF; i++) print $i}')"
    index+=1
done <<< "$(wmctrl -l -p)"

function gen_entries()
{
    for a in $(seq 0 $(( ${#TITLES[@]} -1 )))
    do
        echo ${TITLES[a]}
    done
}

selections=$( gen_entries | ${_rofi} -dmenu -p "window to move" -format i )
[ "$selections" = "" ] && exit

while read -r selection; do
    if [ "$selection" != -1 ]; then
        window_id=$(printf "%d" "${IDS[selection]}")
        i3-msg "[ id = $window_id ] move workspace current, focus" > /dev/null
    fi
done <<< "$selections"
