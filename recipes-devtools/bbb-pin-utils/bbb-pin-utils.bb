DESCRIPTION = "BeagleBone Black pin utility"
HOMEPAGE = "https://github.com/mvduin/bbb-pin-utils"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/mvduin/bbb-pin-utils.git;protocol=https;branch=master"
SRCREV = "${AUTOREV}"

PV = "1.0+git${SRCPV}"
S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/usr/bin/
    install -m 0755 show-pins ${D}/usr/bin/
    install -m 0755 gpio-export ${D}/usr/bin/
    install -m 0755 gpio-parse ${D}/usr/bin/
    install -m 0755 list-gpiochips ${D}/usr/bin/
}

FILES:${PN} += "/usr/bin/*"

RDEPENDS:${PN} += "bash perl"
