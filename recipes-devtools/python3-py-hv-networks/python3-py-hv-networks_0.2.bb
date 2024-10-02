DESCRIPTION = "The package provides SAE J1939 support for Python developers"
SECTION = "devel/python"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/TruckHacking/py-hv-networks.git;protocol=https;rev=559d9e1dda2d21bfd7dec611f1e47a84e2fb449d;branch=master"

S = "${WORKDIR}/git"
inherit setuptools3