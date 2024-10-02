DESCRIPTION = "Systemd Serial Forwarding Services for the UTHP"
LICENSE = "CLOSED"

SRC_URI = "file://serial-router \
           file://serial-router.service \
          "

do_install() {
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/serial-router.service ${D}/${base_libdir}/systemd/system/
    install -d ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/serial-router ${D}/usr/bin/
}

FILES:${PN} += "${sysconfdir}/systemd/system/serial-router.service \
                /usr/bin/serial-router \
               "

inherit systemd
SYSTEMD_SERVICE:${PN} = "serial-router.service"
SYSTEMD_AUTO_ENABLE = "enable"
RDEPENDS:${PN} += "python3-pyserial python3-core python3"