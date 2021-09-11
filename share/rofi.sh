#!/usr/bin/env zsh

# This is a hacky wrapper that runs rofi with zsh rather than bash so that my
# zshenv gets sourced correctly. TODO A more legit solution would be to setup
# bash to emulate my zsh config so that I don't keep running into this issue.

~/.nix-profile/bin/rofi "${@}"
