DESCRIPTION = "PLC4TRUCKSDUCK installation for BeagleBone Black"
LICENSE = "CLOSED"

SRC_URI += " file://plc-dev"

TARGET_DIR = "/opt/uthp/programs/plc-dev"

do_install(){

    # make a backup of development environment
    install -d ${D}${TARGET_DIR}
    cp -r ${WORKDIR}/plc-dev/* ${D}${TARGET_DIR}

    # install programs
    install -d ${D}/usr/bin
    install -d ${D}/lib/firmware

    # firmware
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/pru/generated/plc4trucksduck.out ${D}/lib/firmware/am335x-pru0-fw
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/pru/generated/j17084truckduck.out ${D}/lib/firmware/am335x-pru1-fw

    # user space code
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/arm/build/plc4trucksduck_host ${D}/usr/bin
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/arm/build/j17084truckduck_host ${D}/usr/bin

    # services
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/arm/build/plc4ultimatetrucksduck.service ${D}/lib/systemd/system
    install -m 0755 ${S}/plc-dev/plc4trucksduck/src/arm/build/j17084ultimatetruckduck.service ${D}/lib/systemd/system
}

FILES:${PN} += "${TARGET_DIR}"

RDEPENDS:${PN} += "python3-core python3 python bash"
INSANE_SKIP:${PN} += "arch"