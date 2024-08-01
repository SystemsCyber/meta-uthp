# Set the KERNEL_DEFCONFIG variable to point to the custom configuration file
# removed: KERNEL_DEFCONFIG = "defconfig"; removed: file://0001-UTHPKv0.0.patch; removed: file://0001-UTHP-TESTING.patch
            
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
# This only seems to work with a devtool workspace for now. If having issues, just comment out the next line.
SRC_URI += "file://0001-UTHPKv0.0.patch"

# Set the COMPATIBLE_MACHINE variable to include the UTHP
COMPATIBLE_MACHINE = "uthp"
