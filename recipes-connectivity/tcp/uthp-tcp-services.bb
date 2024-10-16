DESCRIPTION = "Systemd TCP Forwarding Services for the UTHP"
LICENSE = "CLOSED"

SRC_URI = "file://tcp-router \
           file://tcp-router.service \
          "

do_install() {
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/tcp-router.service ${D}/${base_libdir}/systemd/system/
    install -d ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/tcp-router ${D}/usr/bin/
}

FILES:${PN} += "${sysconfdir}/systemd/system/tcp-router.service \
                /usr/bin/tcp-router \
               "

inherit systemd
SYSTEMD_SERVICE:${PN} = "tcp-router.service"
SYSTEMD_AUTO_ENABLE = "enable"
RDEPENDS:${PN} += "python3-pyserial python3-core python3"