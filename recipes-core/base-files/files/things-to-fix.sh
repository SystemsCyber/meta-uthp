#!/bin/bash
# Define directories
DTB_DIR="/boot/dtb/uthp/"
EXTLINUX_DIR="/boot/p1/extlinux/uthp/"
EXTLINUX_CONF="/boot/p1/extlinux/extlinux.conf"
# This file contains things that the Yocto build configuration needs to fix
# Should be run from the uthp home folder

# 1. change ownership of the home folder
sudo chown -R uthp:uthp .

# 2. set-timezone
sudo timedatectl set-timezone America/Denver

# 3. add dtbs

# Ensure the target directory exists
sudo mkdir -p "$EXTLINUX_DIR"

# Empty FDTOVERLAYS line to build
FDTOVERLAYS_LINE="FDTOVERLAYS "

# Iterate over all dtbo files in the DTB_DIR
for dtbo_file in "$DTB_DIR"*.dtbo; do
    if [ -f "$dtbo_file" ]; then
        # Copy each .dtbo file to the EXTLINUX_DIR
        sudo cp "$dtbo_file" "$EXTLINUX_DIR"

        # Extract the filename (without the full path)
        dtbo_filename=$(basename "$dtbo_file")

        # Append the filename to the FDTOVERLAYS line
        FDTOVERLAYS_LINE="$FDTOVERLAYS_LINE /boot/p1/extlinux/uthp/$dtbo_filename"
    fi
done

# Create a backup of the current extlinux.conf file
sudo cp "$EXTLINUX_CONF" "${EXTLINUX_CONF}.backup"

# Remove any existing FDTOVERLAYS line from extlinux.conf and preserve the other contents
sudo sed -i '/^FDTOVERLAYS /d' "$EXTLINUX_CONF"

# Append the new FDTOVERLAYS line at the end of the file
echo "$FDTOVERLAYS_LINE" | sudo tee -a "$EXTLINUX_CONF" > /dev/null

# Output the changes
echo "Updated extlinux.conf with the following FDTOVERLAYS:"
echo "$FDTOVERLAYS_LINE"
