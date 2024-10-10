DESCRIPTION = "The package provides SAE J1939 support for Python developers"
SECTION = "devel/python"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/TruckHacking/py-hv-networks.git;protocol=https;rev=559d9e1dda2d21bfd7dec611f1e47a84e2fb449d;branch=master"

S = "${WORKDIR}/git"
inherit setuptools3

do_install(){
    # install modules
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    install -m 0644 -t ${D}${PYTHON_SITEPACKAGES_DIR} ${S}/hv_networks/*

    # install scripts
    install -d ${D}${bindir}
    install -m 0755 ${S}/j1708dump.py ${D}${bindir}
    install -m 0755 ${S}/j1708send.py ${D}${bindir}
    install -m 0755 ${S}/test_j1587_driver.py ${D}${bindir}
}