#!/usr/bin/env bash

# Forked from https://github.com/davatorium/rofi/blob/b9e28942bf3f287d3326026708dfd449442ba9b6/Examples/i3_empty_workspace.sh

MAX_DESKTOPS=20

WORKSPACES=$(seq -s '\n' 1 1 "${MAX_DESKTOPS}")

EMPTY_WORKSPACE=$( (i3-msg -t get_workspaces | tr ',' '\n' | grep num | awk -F: '{print int($2)}' ; \
            echo -e "${WORKSPACES}" ) | sort -n | uniq -u | head -n 1)

i3-msg workspace "${EMPTY_WORKSPACE}"
