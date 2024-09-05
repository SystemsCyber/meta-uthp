SUMMARY = "CMAP: Can Bus Mapper"
DESCRIPTION = "cmap - CAN bus map visualization tool"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/CanBusHack/cmap.git;branch=master;protocol=https"
SRCREV = "cb3cf1d29e1d99fb9f4fa863f7246c0df4d9c920"

S = "${WORKDIR}/git"

inherit python3native

TARGET_DIR = "/home/uthp/cmap"

do_install() {
    # Create target directory in /home/uthp
    install -d ${D}${TARGET_DIR}

    # Install everything in the target directory
    cp -r ${S}/* ${D}${TARGET_DIR}
}

FILES:${PN} += "${TARGET_DIR}"