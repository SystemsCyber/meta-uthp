FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://BB-UTHP-DCAN.dtbo \
            file://MCP251xFD-SPI.dtbo"
LICENSE = "CLOSED"

do_install() {
    install -d ${D}/boot/dtb/
    install -m 0644 ${WORKDIR}/BB-UTHP-DCAN.dtbo ${D}/boot/dtb/
    install -m 0644 ${WORKDIR}/MCP251xFD-SPI.dtbo ${D}/boot/dtb/
}

FILES:${PN} += "/boot/dtb/*"