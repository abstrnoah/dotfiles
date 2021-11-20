#!/bin/bash

# set -x

count_marks() {
    i3-msg -t get_marks | jq 'map(match("^_alt[01]$"))|length' -r
}

# mark(n) -> void
# Where n in {0,1}.
mark() {
    local _n="${1}"
    i3-msg "mark --add _alt${_n}"
}

clear_marks() {
    i3-msg unmark _alt0
    i3-msg unmark _alt1
}


if [ $(count_marks) -eq 0 ]; then
    mark 0
elif [ $(count_marks) -eq 1 ]; then
    mark 1
else
    clear_marks
    mark 0
fi
