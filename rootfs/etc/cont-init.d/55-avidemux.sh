#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Generate machine id.
if [ ! -f /config/machine-id ]; then
    echo "generating machine-id..."
    cat /proc/sys/kernel/random/uuid | tr -d '-' > /config/machine-id
fi

# Create configuration directories.
mkdir -p /config/.avidemux6
mkdir -p /config/xdg/config

# Copy default configuration if needed.
[ -f /config/.avidemux6/config3 ] || cp /defaults/config3 /config/.avidemux6/config3
[ -f /config/.avidemux6/QtSettings.ini ] || cp /defaults/QtSettings.ini /config/.avidemux6/QtSettings.ini

# Handle dark mode.
if is-bool-val-true "${DARK_MODE:-0}"; then
    sed -i 's/^theme=.*/theme=2/' /config/.avidemux6/QtSettings.ini
else
    sed -i 's/^theme=.*/theme=1/' /config/.avidemux6/QtSettings.ini
fi

# vim:ft=sh:ts=4:sw=4:et:sts=4
