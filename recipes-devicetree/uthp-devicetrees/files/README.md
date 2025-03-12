# Welcome to the update-overlays recipe

This tool is intended to make the process of updating the overlays on the UTHP devices easier, and is installed in /usr/bin/update-overlays.

## Usage
1. Put any overlays you would like to update in the /boot/dts/uthp/ directory of the UTHP device. Then, run the following command:
```bash
update-overlays
```
2. Reboot the device to apply the changes.