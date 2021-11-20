#!/bin/bash

# set -x

get_focused_mark() {
    i3-msg -t get_tree \
        | jq -r '..|select(objects and .focused == true).marks|map(match("^_alt[01]$"))?|first(.[])|.string'
}

case $(get_focused_mark) in
    _alt0)
        i3-msg '[con_mark="_alt1"] focus'
        ;;
    _alt1)
        i3-msg '[con_mark="_alt0"] focus'
        ;;
    *)
        i3-msg '[con_mark="_alt0"] focus'
        ;;
esac
