#!/usr/bin/env zsh

# set -x

source "${BR_DOTFILES}/share/utilities.zsh" || exit -1

_NIX_BIN="/nix/var/nix/profiles/per-user/abstractednoah/profile/bin"
_ALT_BIN="/usr/bin"

_nix_has() {
    local _command="${1}"
    test -x "${_NIX_BIN}/${_command}" || _br_oops "Missing: ${_command}"
}

_update_alternative() {
    local _name="${1}"
    local _command="${2}"
    _nix_has "${_command}" || return
    test -n "${_name}" \
        || _br_oops "Alternative name empty" \
        || return
    update-alternatives --verbose --install \
        "${_ALT_BIN}/${_name}" \
        "${_name}" \
        "${_NIX_BIN}/${_command}" \
        0
    update-alternatives --verbose --set "${_name}" "${_NIX_BIN}/${_command}"
}

_update_alternative editor vim
_update_alternative x-www-browser qutebrowser
_update_alternative gnome-www-browser qutebrowser
