FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://BB-UTHP-DCAN.dtbo \
            file://BB-UTHP-DCAN.dts \
            file://BB-PLC4TRUCKSDUC-00A0.dtbo \
            file://BB-PLC4TRUCKSDUC-00A0.dts \
            file://MCP251xFD-SPI.dtbo \
            file://MCP251xFD-SPI.dts \
            "

LICENSE = "CLOSED"
### REMEMBER TO dtc -O dtb -o <something>.dtbo -b 0 -@ <something>.dts ###
do_install() {
    install -d ${D}/boot/dtb/uthp
    install -d ${D}/boot/dts/uthp
    install -m 0644 ${WORKDIR}/*.dtbo ${D}/boot/dtb/uthp
    install -m 0644 ${WORKDIR}/*.dts ${D}/boot/dts/uthp
}

FILES:${PN} += "/boot/*"