#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Generate machine id.
echo "[cont-init.d] $(basename "$0"): Generating machine-id..."
cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id

# Create configuration directories.
mkdir -p /config/.avidemux6
mkdir -p /config/xdg/config

# Copy default configuration if needed.
[ -f /config/.avidemux6/config3 ] || cp /defaults/config3 /config/.avidemux6/config3
[ -f /config/xdg/config/QtProject.conf ] || cp /defaults/QtProject.conf /config/xdg/config/QtProject.conf

# Take ownership of the config directory content.
chown -R $USER_ID:$GROUP_ID /config/*

# vim: set ft=sh :
