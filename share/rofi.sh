#!/bin/sh

export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"
~/.nix-profile/bin/rofi "${@}"
