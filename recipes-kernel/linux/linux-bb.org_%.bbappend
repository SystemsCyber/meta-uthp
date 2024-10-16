FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-uthp-rtc.patch"
# uncomment the following line to apply the PLC patch
# SRC_URI += "file://0001-uthp-plc.patch"
            
# Set the COMPATIBLE_MACHINE variable to include the UTHP
COMPATIBLE_MACHINE = "uthp"
