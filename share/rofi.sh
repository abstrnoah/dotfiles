#!/bin/sh

# This is a hacky quick fix. TODO: Somehow rofi needs to run in the presence of
# zshenv, but sourcing it directly in here doesn't seem to work, plus that's
# also hacky.
export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"
export QT_XCB_GL_INTEGRATION=none

~/.nix-profile/bin/rofi "${@}"
