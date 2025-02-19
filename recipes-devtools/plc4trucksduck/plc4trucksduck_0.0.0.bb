DESCRIPTION = "PLC4TRUCKSDUCK installation for the UTHP"
LICENSE = "CLOSED"

SRC_URI += " file://plc-dev"

TARGET_DIR = "/opt/uthp/programs/plc-dev"

do_install(){

    # make a backup of development environment
    install -d ${D}${TARGET_DIR}
    cp -r ${WORKDIR}/plc-dev/* ${D}${TARGET_DIR}

    # install program directories
    install -d ${D}/usr/bin
    install -d ${D}/usr/lib/firmware
    install -d ${D}/usr/lib/systemd/system

    # firmware (needs to be copied becuase of objcopy errors in Yocto)
    cp ${WORKDIR}/plc-dev/plc4trucksduck/src/pru/generated/plc4trucksduck.out ${D}/usr/lib/firmware/am335x-pru0-fw
    cp ${WORKDIR}/plc-dev/plc4trucksduck/src/pru/generated/j17084truckduck.out ${D}/usr/lib/firmware/am335x-pru1-fw

    # user space code (has to be root to access PRU)
    install -m 0755 ${WORKDIR}/plc-dev/plc4trucksduck/src/arm/plc4trucksduck_host ${D}/usr/bin
    install -m 0755 ${WORKDIR}/plc-dev/plc4trucksduck/src/arm/j17084truckduck_host ${D}/usr/bin

    # services
    install -m 0755 ${WORKDIR}/plc-dev/plc4trucksduck/src/arm/j17084truckduck.service ${D}/usr/lib/systemd/system/j17084truckduck.service
    install -m 0755 ${WORKDIR}/plc-dev/plc4trucksduck/src/arm/plc4trucksduck.service ${D}/usr/lib/systemd/system/plc4trucksduck.service

    # just in case the user wants to force stop the PRU
    ln -s ${WORKDIR}/plc-dev/plc4trucksduck/stop_remoteproc ${D}/usr/bin/stop_remoteproc
}

FILES:${PN} += "${TARGET_DIR} \
                /usr/lib/*"

# only one can be enabled at a time with PRU resources available
SYSTEMD_AUTO_ENABLE += "j17084truckduck.service"

RDEPENDS:${PN} += "python3-core python3 python bash"
INSANE_SKIP:${PN} += "arch"
