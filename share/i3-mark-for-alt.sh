#!/bin/bash

# set -x

count_marks() {
    i3-msg -t get_marks \
        | jq 'map(match("^_alt[01]$"))|length' -r
}

get_last_mark() {
    i3-msg -t get_marks \
        | jq 'map(match("^_alt[01]$"))|map(.string)|sort|last(.[])' -r
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

if [ $(count_marks) -ge 2 ]; then
    clear_marks
    mark 0
else
    case $(get_last_mark) in
        _alt0)
            mark 1
            ;;
        _alt1)
            mark 0
            ;;
        *)
            clear_marks
            mark 0
            ;;
    esac
fi
