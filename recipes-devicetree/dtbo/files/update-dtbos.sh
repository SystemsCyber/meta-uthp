#!/bin/bash
# # UTHP Testing extlinux.conf file
# LABEL TruckHackingOS Testing Image (Poky Scarthgap 5.0.2 reference distro)
#         KERNEL ../zImage
#         FDTDIR ../
#         APPEND root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait console=ttyS0,115200n8,115200
#         FDTOVERLAYS     /boot/dtbo/MCP251xFD-SPI.dtbo \
#                         /boot/dtbo/BB-UTHP-DCAN.dtbo
#                         # /lib/firmware/overlays/<your-overlay>.dtbo
# Path to the directory containing dtbo files
DTBO_DIR="/boot/dtbo"

# Path to the extlinux.conf file
EXTLINUX_CONF="/boot/p1/extlinux/extlinux.conf"
EXTLINUX="/boot/p1/extlinux"

# Function to add fdtoverlay to extlinux.conf
add_fdtoverlay() {
    local dtbo_file=$1
    local dtbo_filename=$(basename "${dtbo_file}")

    # Check if the fdtoverlay is already present in extlinux.conf
    if grep -q "${dtbo_filename}" "${EXTLINUX_CONF}"; then
        echo "${dtbo_filename} is already present in extlinux.conf"
    else
        mv "${dtbo_file}" "${EXTLINUX}"
        echo "Adding ${dtbo_filename} to extlinux.conf"
        # check if FDToverlays is already present in extlinux.conf
        if ! grep -q "FDTOVERLAYS" "${EXTLINUX_CONF}"; then
            echo "        FDTOVERLAYS     ${dtbo_filename}" >> "${EXTLINUX_CONF}"
        else
            # add the overlay after the existing FDTOVERLAYS
            sed -i "/FDTOVERLAYS/ s/$/ \\\n                        ${dtbo_filename}/" "${EXTLINUX_CONF}"
        fi
    fi
}

# Main script logic
while true; do
    # Check if there are any new dtbo files in the directory
    new_dtbo_files=$(find "${DTBO_DIR}" -type f -name "*.dtbo" -newer "${EXTLINUX_CONF}")

    if [[ -n "${new_dtbo_files}" ]]; then
        echo "New dtbo files found:"
        echo "${new_dtbo_files}"

        # Iterate over the new dtbo files and add them to extlinux.conf
        while IFS= read -r dtbo_file; do
            add_fdtoverlay "${dtbo_file}"
        done <<< "${new_dtbo_files}"
    else
        echo "No new dtbo files found"
    fi

    # Sleep for 10 seconds before checking again
    sleep 10
done