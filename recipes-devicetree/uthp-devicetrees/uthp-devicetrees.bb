FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://BB-UTHP-DCAN.dts \
            file://BB-PLC4TRUCKSDUC-00A0.dts \
            file://MCP251xFD-SPI.dts \
            file://BB-UART5-00A0.dts \
            file://update-overlays \
            file://Makefile \
            "

LICENSE = "CLOSED"
### REMEMBER TO dtc -O dtb -o <something>.dtbo -b 0 -@ <something>.dts ###
do_install() {
    install -d ${D}/boot/dtb/uthp
    install -d ${D}/boot/dts/uthp
    install -m 0644 ${WORKDIR}/*.dts ${D}/boot/dts/uthp
    # install makefile
    install -m 0644 ${WORKDIR}/Makefile ${D}/boot/dts/uthp

    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/update-overlays ${D}/usr/bin
}

RDEPENDS:${PN} += "bash"

FILES:${PN} += "/boot/* /usr/bin/*"