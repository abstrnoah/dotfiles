#!/bin/bash

# This is extremely hackily put together from the other forked rofi scripts
# here, it is a TODO to clean these scripts up but for now they work :)

_dotfiles_scripts="${HOME}/.dotfiles/share"
_rofi="${_dotfiles_scripts}/rofi.sh"

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

WORKSPACE=$( (echo "-"; gen_workspaces)  | "${_rofi}" -dmenu -p "move to ws")

if [ x"-" = x"${WORKSPACE}" ]
then
    WORKSPACE=$("$_dotfiles_scripts/empty-workspace.sh")
fi
if [ -n "${WORKSPACE}" ]
then
    i3-msg "move window to workspace ${WORKSPACE}"
fi
