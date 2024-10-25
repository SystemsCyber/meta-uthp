DESCRIPTION = "The package provides SAE J1939 support for Python developers"
SECTION = "devel/python"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/TruckHacking/py-hv-networks.git;protocol=https;rev=559d9e1dda2d21bfd7dec611f1e47a84e2fb449d;branch=master"

S = "${WORKDIR}/git"
inherit setuptools3

# TODO: test this
do_install(){
    # install scripts
    install -d ${D}${bindir}
    install -m 0755 ${S}/j1708dump.py ${D}${bindir}/j1708dump
    install -m 0755 ${S}/j1708send.py ${D}${bindir}/j1708send

    # install everything just in case
    install -d ${D}${python_sitepackagesdir}/hv_networks
    install -m 0644 ${S}/hv_networks/* ${D}${python_sitepackagesdir}/hv_networks
    
    # TODO: add export PYTHONPATH=/usr/lib/python3.12/site-packages/hv_networks-0.2-py3.12.egg/hv_networks/:$PYTHONPATH
}

FILES:${PN} += "*"