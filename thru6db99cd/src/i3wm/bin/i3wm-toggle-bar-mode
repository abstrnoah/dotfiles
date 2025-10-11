#!/bin/bash

get_bar_mode() {
    i3-msg -t get_bar_config bar-0 | jq -r .mode
}

case $(get_bar_mode) in
    dock)
        i3-msg bar mode hide
        ;;
    hide|invisible)
        i3-msg bar mode dock
        ;;
    *)
        exit -1
        ;;
esac
