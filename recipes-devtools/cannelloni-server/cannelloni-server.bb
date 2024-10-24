FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DESCRIPTION = "Cannelloni Server Service for UTHP"
SUMMARY = "Must be configured with /opt/uthp/scripts/cannelloni-server/cannelloni-server.conf"
LICENSE = "CLOSED"

SRC_URI = "file://start.sh \
           file://cannelloni-server.conf \
           file://spawn-cannelloni-server.service \
          "

do_install() {
    install -d ${D}/opt/uthp/scripts/cannelloni-server
    install -m 0755 ${WORKDIR}/start.sh ${D}/opt/uthp/scripts/cannelloni-server
    install -m 0644 ${WORKDIR}/cannelloni-server.conf ${D}/opt/uthp/scripts/cannelloni-server
    install -d ${D}/etc/systemd/system
    install -m 0644 ${WORKDIR}/spawn-cannelloni-server.service ${D}/etc/systemd/system
}

FILES:${PN} += "/opt/uthp/scripts/cannelloni-server/* \
                /etc/systemd/system/spawn-cannelloni-server.service \
               "

RDEPENDS:${PN} += "systemd bash"