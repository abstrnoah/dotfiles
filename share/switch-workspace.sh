#!/bin/bash

# set -x

# Forked from https://github.com/davatorium/rofi-scripts/blob/889056584d67d55c2a7a877d4e3b688bf2e40f7b/i3_switch_workspace.sh

_dotfiles_scripts="${HOME}/.dotfiles/share"

_rofi="${_dotfiles_scripts}/rofi.sh"

function gen_workspaces()
{
    i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}


WORKSPACE=$( (echo "-"; gen_workspaces)  | "${_rofi}" -dmenu -p "workspace")

if [ x"-" = x"${WORKSPACE}" ]
then
    WORKSPACE=$("$_dotfiles_scripts/empty-workspace.sh")
fi
if [ -n "${WORKSPACE}" ]
then
    i3-msg workspace "${WORKSPACE}"
fi