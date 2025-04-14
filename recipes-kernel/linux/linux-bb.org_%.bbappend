FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-rtc.patch \
            file://0001-intc-plc.patch"
            
# Set the COMPATIBLE_MACHINE variable to include the UTHP
COMPATIBLE_MACHINE = "uthp"
