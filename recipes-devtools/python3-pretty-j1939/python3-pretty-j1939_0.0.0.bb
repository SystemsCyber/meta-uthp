DESCRIPTION = "python libs and scripts for pretty-printing J1939 logs"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

# Specify the source file location
SRC_URI = "git://github.com/nmfta-repo/pretty_j1939.git;protocol=https;rev=4e5c497bfd12ba89fb95b4711309603e5a1e586d;branch=master"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://.env"

S = "${WORKDIR}/git"

do_install:append() {
    install -d ${D}/usr/bin
    install -d ${D}/opt/uthp/programs/pretty_j1939
    cp -r ${S}/* ${D}/opt/uthp/programs/pretty_j1939
    install -m 0755 ${WORKDIR}/.env ${D}/opt/uthp/programs/pretty_j1939

    # links to a environment file that runs the program
    ln -s /opt/uthp/programs/pretty_j1939/.env ${D}/usr/bin/pretty_j1939

    # make it executable after copying
    chmod +x ${D}/opt/uthp/programs/pretty_j1939/pretty_j1939.py
}

RDEPENDS:${PN} += "python3-bitarray bash"

FILES:${PN} += "/opt/uthp/programs/pretty_j1939 \
                /usr/bin/pretty_j1939"