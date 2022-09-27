#!/usr/bin/env zsh

# set -x

session_name="$(tmux list-sessions -F '#S' | fzf-tmux -p)"
session_name="${session_name//./_}" # dots confuse tmux
test -n "${session_name}" || exit 0

tmux has-session -t="${session_name}" 2> /dev/null || {
    tmux new-session -d -s "${session_name}" -c "${start_directory}"
}
if test -z "${TMUX}"; then
    tmux attach -t "${session_name}"
else
    tmux switch -t "${session_name}"
fi
