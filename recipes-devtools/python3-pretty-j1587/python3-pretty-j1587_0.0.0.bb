DESCRIPTION = "This is a tool for getting detailed decodings of J1587/J1708 (and J2497) messages using the J1587 and J1708 specification PDFs as a reference"
SECTION = "devel/python"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://${THISDIR}/LICENSE;md5=9cbb8e86b6798efc990e6ac9a33a8b14"

# Specify the source file location
SRC_URI = "git://github.com/ainfosec/pretty_j1587.git;protocol=https;rev=31ac605d1c0dbcf4fde366e278d20382e3617476;branch=master"
SRC_URI[sha256sum] = "7c72341c6e872d9b9e10a681d77a407e8e2cf4e1b88a315e24bd82a938496ad2"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "python3-core python3 python"

do_install() {
    install -d ${D}/opt/uthp/programs/pretty_j1587
    install -d ${D}/usr/bin

    cp -r ${S}/* ${D}/opt/uthp/programs/pretty_j1587

    ln -s /opt/uthp/programs/pretty_j1587/pretty_j1587.py ${D}/usr/bin/pretty_j1587
}

FILES:${PN} += "/opt/uthp/programs/pretty_j1587"