#!/bin/bash

# This is extremely hackily put together from the other forked rofi scripts
# here, it is a TODO to clean these scripts up but for now they work :)

# Requires: wmctrl

_dotfiles_scripts="${HOME}/.dotfiles/share"
_rofi="${_dotfiles_scripts}/rofi.sh"

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

WORKSPACE=$( (echo empty; gen_workspaces)  | "${_rofi}" -dmenu -p "move to ws")

MAX_DESKTOPS=20

WORKSPACES=$(seq -s '\n' 1 1 "${MAX_DESKTOPS}")

if [ x"empty" = x"${WORKSPACE}" ]
then
    WORKSPACE=$( (i3-msg -t get_workspaces | tr ',' '\n' | grep num | awk -F: '{print int($2)}' ; \
            echo -e "${WORKSPACES}" ) | sort -n | uniq -u | head -n 1)
    echo ${WORKSPACE}
fi
if [ -n "${WORKSPACE}" ]
then
    i3-msg "move window to workspace ${WORKSPACE}"
fi
