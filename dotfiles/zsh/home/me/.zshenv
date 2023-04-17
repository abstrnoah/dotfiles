# zshenv

nix_profile_daemon="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
if test -f "${nix_profile_daemon}"; then source "${nix_profile_daemon}"; fi

export NIXPHILE_ENV="${HOME}/.nixphile/env"
nixphile_paths="${NIXPHILE_ENV}/bin:${HOME}/.nixphile/bin"


export PATH="${nixphile_paths}:${HOME}/.bin:${HOME}/.local/bin:${PATH}:/sbin:/opt/jabref/bin"
export EDITOR="${NIXPHILE_ENV}/bin/vim"
export VISUAL="${EDITOR}"
export BROWSER="${NIXPHILE_ENV}/bin/qutebrowser"
export XDG_DATA_DIRS="${NIXPHILE_ENV}/share:${XDG_DATA_DIRS}:/usr/share"

# Make locales work with Nix.
export LOCALE_ARCHIVE="$(readlink -f "${NIXPHILE_ENV}/lib/locale")/locale-archive"

# Use nix's Java.
export JAVA_HOME="${NIXPHILE_ENV}/lib/openjdk"

# Enable firefox touch screen scrolling.
export MOZ_USE_XINPUT2=1

export GTK_THEME=Adwaita:dark

# for `rlue/timer`
export AUDIODRIVER=alsa
