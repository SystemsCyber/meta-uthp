DESCRIPTION = "Systemd Serial Forwarding Services for the UTHP"
LICENSE = "CLOSED"

SRC_URI = "file://j1708_grimm_encoder \
           file://j1708-grimm-encoder.service \
           file://serial-getty@ttyGS0.service \
           file://truckdevil-serial.service \
           file://truck_devil_serial.c \
           file://truck_devil_serial \
           file://Makefile \
          "

do_install() {
    #### Service Files ####
    # Install the serial-getty service
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/serial-getty@ttyGS0.service ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/truckdevil-serial.service ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/j1708-grimm-encoder.service ${D}/${base_libdir}/systemd/system/

    #### Programs ####
    install -d ${D}/usr/bin/
    # Install the truck_devil_serial.c
    install -d ${D}/opt/uthp/programs/truckdevil/serial/src/
    install -m 0644 ${WORKDIR}/truck_devil_serial.c ${D}/opt/uthp/programs/truckdevil/serial/src/
    install -m 0644 ${WORKDIR}/Makefile ${D}/opt/uthp/programs/truckdevil/serial/
    install -m 0755 ${WORKDIR}/truck_devil_serial ${D}/opt/uthp/programs/truckdevil/serial/
    ln -s /opt/uthp/programs/truckdevil/serial/truck_devil_serial ${D}/usr/bin/truck_devil_serial

    # Install the j1708_grimm_encoder
    install -m 0755 ${WORKDIR}/j1708_grimm_encoder ${D}/usr/bin/j1708_grimm_encoder
}

FILES:${PN} += "*"
INSANE_SKIP = "32bit-time"

# TODO: check if these were actually enabled
inherit systemd
SYSTEMD_SERVICE:${PN} += " truckdevil-serial.service j1708-grimm-encoder.service"
SYSTEMD_AUTO_ENABLE = "enable"
RDEPENDS:${PN} += "python3-pyserial python3-core python3 bash"