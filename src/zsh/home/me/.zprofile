# ~/.zprofile: user .zprofile file for zsh(1).
#
# This file is sourced only for login shells (i.e. shells
# invoked with "-" as the first character of argv[0], and
# shells invoked with the -l flag.)
#
# Global Order: zshenv, zprofile, zshrc, zlogin

test -f /etc/profile || exit

_old_path="${PATH}"

# Bring in system-wide profile via emulation.
# See
# https://unix.stackexchange.com/questions/537637/sshing-into-system-with-zsh-as-default-shell-doesnt-run-etc-profile
# for a great explanation + massive flowchart of when config files are sourced.
emulate sh -c 'source /etc/profile'

# Prepend our path since /etc/profile seems to overwrite instead of prepending
# as one might expect.
PATH="${_old_path}:${PATH}"
