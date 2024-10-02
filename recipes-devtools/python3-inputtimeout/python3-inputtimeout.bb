SUMMARY = "A Python library to input with a timeout"
HOMEPAGE = "https://github.com/johejo/inputimeout"
LICENSE = "CLOSED"
SRC_URI = "git://github.com/johejo/inputimeout.git;branch=master;rev=v1.0.4;protocol=https"

S = "${WORKDIR}/git"

DEPENDS += "python3-setuptools-native python3-pip-native"

inherit setuptools3

RDEPENDS:${PN} += " \
    python3-can \
    python3 \
"