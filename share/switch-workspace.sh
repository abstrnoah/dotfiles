#!/bin/bash

# Forked from https://github.com/davatorium/rofi-scripts/blob/889056584d67d55c2a7a877d4e3b688bf2e40f7b/i3_switch_workspace.sh

_dotfiles_scripts="${HOME}/.dotfiles/share"

_rofi="${_dotfiles_scripts}/rofi.sh"
_empty_workspace="${_dotfiles_scripts}/empty-workspace.sh"

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}


WORKSPACE=$( (echo empty; gen_workspaces)  | "${_rofi}" -dmenu -p "workspace")

if [ x"empty" = x"${WORKSPACE}" ]
then
    "${_empty_workspace}"
elif [ -n "${WORKSPACE}" ]
then
    i3-msg workspace "${WORKSPACE}"
fi
