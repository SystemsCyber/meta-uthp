SUMMARY = "CMAP: Can Bus Mapper"
DESCRIPTION = "cmap - CAN bus map visualization tool"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/CanBusHack/cmap.git;branch=master;protocol=https"
SRCREV = "cb3cf1d29e1d99fb9f4fa863f7246c0df4d9c920"

S = "${WORKDIR}/git"

inherit python3native

TARGET_DIR = "/opt/uthp/programs/cmap"

do_install() {
    install -d ${D}${TARGET_DIR}
    install -d ${D}/usr/bin
    cp -r ${S}/* ${D}${TARGET_DIR}

    # Create a symlink to the sample program
    ln -s ${TARGET_DIR}/scan_with_class.py ${D}/usr/bin/cmap
    chmod +x ${D}/${TARGET_DIR}/scan_with_class.py
}

# Quickly edit the shebang line
do_compile() {
    sed -i '1i #!/usr/bin/python3' ${S}/scan_with_class.py
}

FILES:${PN} += "${TARGET_DIR}"

# need to add these dependencies
RDEPENDS:${PN} += "python3-can-isotp python3-inputtimeout python3-core"
