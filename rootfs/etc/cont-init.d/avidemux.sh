#!/usr/bin/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

log() {
    echo "[cont-init.d] $(basename $0): $*"
}

# Generate machine id.
if [ ! -f /etc/machine-id ]; then
    log "generating machine-id..."
    cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id
fi

# Create configuration directories.
mkdir -p /config/.avidemux6
mkdir -p /config/xdg/config

# Copy default configuration if needed.
[ -f /config/.avidemux6/config3 ] || cp /defaults/config3 /config/.avidemux6/config3
[ -f /config/xdg/config/QtProject.conf ] || cp /defaults/QtProject.conf /config/xdg/config/QtProject.conf

# Take ownership of the config directory content.
find /config -mindepth 1 -exec chown $USER_ID:$GROUP_ID {} \;

# vim: set ft=sh :
