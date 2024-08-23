DESCRIPTION = "USB Gadget Setup for BeagleBone Black"
LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://bb-usb-gadgets.service \
            file://bb-start-usb-gadgets \
            file://bb-start-acm-ncm-rndis-old-gadget \
            file://bb-mac-addr \
            file://bb-setup-mac-address \
            file://bb-boot \
            file://bbb.io/ \
            "

do_install() {
    # install startup services
    install -d ${D}/${base_libdir}/systemd/system/
    install -m 0644 ${WORKDIR}/bb-usb-gadgets.service ${D}/${base_libdir}/systemd/system/

    install -d ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/bb-start-usb-gadgets ${D}/usr/bin/
    install -m 0755 ${WORKDIR}/bb-start-acm-ncm-rndis-old-gadget ${D}/usr/bin/

    # configuration files
    install -d ${D}/etc/default/
    install -m 0755 ${WORKDIR}/bb-mac-addr ${D}/etc/default/
    install -m 0755 ${WORKDIR}/bb-boot ${D}/etc/default/
    
    # install bbb.io recursively
    install -d ${D}/bbb.io/
    cp -r ${WORKDIR}/bbb.io/* ${D}/bbb.io/
}

FILES:${PN} += "*"

inherit systemd
SYSTEMD_SERVICE:${PN} = "bb-usb-gadgets.service"
SYSTEMD_AUTO_ENABLE = "enable"
RDEPENDS:${PN} = " bash"
