DESCRIPTION = "CanCat is an open source multi-purpose tool for interacting and experimenting with Controller Area Networks (CAN), such as those that are often used in cars, building automation, etc."
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=8b3ee565c01ecbc32e19d6f71b0047ab"

# Specify the source file location
SRC_URI = "git://github.com/atlas0fd00m/CanCat.git;protocol=https;branch=master;rev=9729abf99cb53d5d20cc05ad540deb82ede606a2"
SRC_URI[sha256sum] = "cd4399078ed0d7cfea6e76f03fc0ac7e069885f552c6cf9c4474d108b066f56e"

S = "${WORKDIR}/git"

inherit setuptools3

