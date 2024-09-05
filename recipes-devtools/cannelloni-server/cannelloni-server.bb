FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DESCRIPTION = "Cannelloni Server Service for UTHP"
SUMMARY = "Must be configured with /opt/scripts/cannelloni-server/cannelloni-server.conf"
LICENSE = "CLOSED"

SRC_URI = "file://start.sh \
           file://spawn-cannelloni-server.service \
          "

do_install() {
    install -d ${D}/opt/scripts/cannelloni-server
    install -m 0755 ${WORKDIR}/start.sh ${D}/opt/scripts/cannelloni-server
    install -d ${D}/etc/systemd/system
    install -m 0644 ${WORKDIR}/spawn-cannelloni-server.service ${D}/etc/systemd/system
}

FILES:${PN} += "/opt/scripts/cannelloni-server \
                /etc/systemd/system/spawn-cannelloni-server.service \
               "

RDEPENDS:${PN} += "systemd bash"