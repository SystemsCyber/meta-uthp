DESCRIPTION = "This is a tool for getting detailed decodings of J1587/J1708 (and J2497) messages using the J1587 and J1708 specification PDFs as a reference"
SECTION = "devel/python"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://${THISDIR}/LICENSE;md5=9cbb8e86b6798efc990e6ac9a33a8b14"

# Specify the source file location
# Using this specific fork until the changes are merged into the main branch
SRC_URI = "git://github.com/Spenc3rB/pretty_j1587;protocol=https;rev=ebd9c4d2377216919c85c45a3da2d168694c68f5;branch=master"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://config.cfg"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "python3-core python3 python"

do_install() {
    install -d ${D}/opt/uthp/programs/pretty_j1587
    install -d ${D}/usr/bin

    cp -r ${S}/* ${D}/opt/uthp/programs/pretty_j1587
    install -m 0644 ${WORKDIR}/config.cfg ${D}/opt/uthp/programs/pretty_j1587

    ln -s /opt/uthp/programs/pretty_j1587/pretty_j1587.py ${D}/usr/bin/pretty_j1587
}

FILES:${PN} += "/opt/uthp/programs/pretty_j1587"