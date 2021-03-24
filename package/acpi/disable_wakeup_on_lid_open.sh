#!/bin/sh

# Helper script to disable wakeup on lid open on Ubuntu with acpi installed
# (implmeneted via systemd service).
#
# Author: abstractednoah@brumal.org Path:
# /usr/share/brumal-utils/disable_wakeup_on_lid_open.sh

path=/proc/acpi/wakeup

# Get status of LID setting, we expect "*enabled" or "*disabled".
get_status() {
    echo $(awk '{if ($1 == "LID") print $3;}' "${path}")
}

# Abort with error if path missing.
[ -f "${path}" ] || exit 1

# Disable wakeup on lid open if enabled.
[ $(get_status) = "*enabled" ] && echo "LID" > ${path}

# Check that disabled now.
[ $(get_status) = "*enabled" ] && exit 1
