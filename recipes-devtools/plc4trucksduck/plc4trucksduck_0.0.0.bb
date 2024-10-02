DESCRIPTION = "PLC4TRUCKSDUCK installation for BeagleBone Black"
LICENSE = "CLOSED"

SRC_URI += " file://plc-dev"

TARGET_DIR = "/opt/uthp/programs/plc-dev"

do_install(){
    install -d ${D}${TARGET_DIR}
    cp -r ${WORKDIR}/plc-dev/* ${D}${TARGET_DIR}

    # figure out symlinks
}

FILES:${PN} += "${TARGET_DIR}"

RDEPENDS:${PN} += "python3-core python3 python bash"
INSANE_SKIP:${PN} += "arch"