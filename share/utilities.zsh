# utilities.zsh
#
# Usage: `source path/to/utilities.zsh`

_br_command_exists () { # commands-to-check...
    while test "${#}" -gt 0; do
        command -v "${1}" &>/dev/null || return 1
        shift
    done
}

_br_oops() { # message
    echo "${1}" 1>&2
    return 1
}

_br_require() { # required-command
    _br_command_exists "${1}" || _br_oops "Required command not found: ${1}"
}

_br_join() {
    local delim="${1}"
    local _delim=''
    shift
    while test "${#}" -gt 0; do
        test -z "${1}" || {
            printf '%s%s' "${_delim}" "${1}"
            _delim="${delim}"
        }
        shift
    done
}

_br_is_torified() {
    _br_command_exists torsocks && {torsocks show | grep -q 'libtorsocks.so'}
}

_br_is_ssh() {
    test -n "${SSH_CONNECTION}"
}

_br_is_git() {
    git rev-parse git-dir > /dev/null 2>&1
}

# MODELINE {{{1
# vim:ft=zsh:fdm=marker:fmr={{{,}}}:fen:tw=80:et:ts=4:sts=4:sw=0:
