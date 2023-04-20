#!/bin/sh

# set -x

# Helper script to disable wakeup on lid open on Ubuntu with acpi installed
# (implmeneted via systemd service).
#
# Author: abstractednoah@brumal.org
# Path: /usr/share/brumal-utils/disable_wakeup_on_lid_open.sh

_path=/proc/acpi/wakeup

# Get status of LID setting, we expect "*enabled" or "*disabled".
get_status() {
    awk '{if ($1 == "LID") print $3;}' "${_path}"
}

# Abort with error if path missing.
[ -f "${_path}" ] || exit 2

# Disable wakeup on lid open if enabled.
[ $(get_status) = "*disabled" ] || echo "LID" > ${_path}

# Check that disabled now.
[ $(get_status) = "*disabled" ] || exit 3
