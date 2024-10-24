DESCRIPTION = "python libs and scripts for pretty-printing J1939 logs"
SECTION = "devel/python"
LICENSE = "CLOSED"

# Specify the source file location
SRC_URI = "git://github.com/nmfta-repo/pretty_j1939.git;protocol=https;rev=199431af9e837f299b171c5a71e3d051ad811e1b;branch=master"
SRC_URI[sha256sum] = "7c72341c6e872d9b9e10a681d77a407e8e2cf4e1b88a315e24bd82a938496ad2"

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