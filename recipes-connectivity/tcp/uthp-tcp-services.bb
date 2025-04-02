DESCRIPTION = "Systemd TCP Forwarding Services for the UTHP"
LICENSE = "MIT"

SRC_URI = "file://truckdevil-tcp.service \
           file://truckdevil-tcp \
          "

do_install() {
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/truckdevil-tcp.service ${D}/${base_libdir}/systemd/system/
    install -d ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/truckdevil-tcp ${D}/usr/bin/
}

FILES:${PN} += "*"

RDEPENDS:${PN} += "python3-pyserial python3-core python3"