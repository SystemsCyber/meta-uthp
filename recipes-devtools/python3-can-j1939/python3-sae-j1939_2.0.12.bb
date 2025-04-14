DESCRIPTION = "The package provides SAE J1939 support for Python developers"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=270a7da88f99df4de0306b545631a96e"

SRC_URI = "git://github.com/juergenH87/python-can-j1939.git;protocol=https;rev=e8303599812e176fe8eb4f867d20fba654109c8c;branch=master"

S = "${WORKDIR}/git"

inherit setuptools3

