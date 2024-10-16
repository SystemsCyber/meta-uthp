SUMMARY = "A Python implementation of the ISO-TP (ISO 15765-2) protocol over CAN."
HOMEPAGE = "https://github.com/pylessard/python-can-isotp"
LICENSE = "CLOSED"
SRC_URI = "git://github.com/pylessard/python-can-isotp.git;branch=v2.x;rev=5bf31a10edb5a5360f4e1a27bba44b29e55d1855;protocol=https"

S = "${WORKDIR}/git"

DEPENDS += "python3-setuptools-native python3-pip-native"

inherit setuptools3

RDEPENDS:${PN} += " \
    python3-can \
    python3 \
"