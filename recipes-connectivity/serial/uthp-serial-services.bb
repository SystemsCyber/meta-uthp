DESCRIPTION = "Systemd Serial Forwarding Services for the UTHP"
LICENSE = "CLOSED"

SRC_URI = "file://serial-router \
           file://serial-router.service \
           file://serial-getty@ttyGS0.service \
           file://truck_devil_serial.c \
           file://Makefile \
          "

do_install() {
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/serial-router.service ${D}/${base_libdir}/systemd/system/
    install -d ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/serial-router ${D}/usr/bin/

    # Install the serial-getty service
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/serial-getty@ttyGS0.service ${D}/${base_libdir}/systemd/system/

    # Install the truck_devil_serial.c
    install -d ${D}/home/uthp/in-development/src/
    install -m 0644 ${WORKDIR}/truck_devil_serial.c ${D}/home/uthp/in-development/src/
    install -m 0644 ${WORKDIR}/Makefile ${D}/home/uthp/in-development/
}

FILES:${PN} += "${sysconfdir}/systemd/system/serial-router.service \
                /usr/bin/serial-router \
                /home/uthp/in-development/ \
               "

inherit systemd
SYSTEMD_SERVICE:${PN} = "serial-router.service serial-getty@ttyGS0.service"
SYSTEMD_AUTO_ENABLE = "enable"
RDEPENDS:${PN} += "python3-pyserial python3-core python3"