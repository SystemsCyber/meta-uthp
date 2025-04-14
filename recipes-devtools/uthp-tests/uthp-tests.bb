DESCRIPTION = "Unit Tests for the UTHP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=a040f2eb23f64c76027fc1a85e4eec8c"

# Specify the source file location
SRC_URI = "git://github.com/Spenc3rB/uthp-tests.git;protocol=https;rev=7ae293d295d867894a4bab7164857f37bad36146;branch=main"

S = "${WORKDIR}/git"

do_configure() {
    :
}
do_compile() {
    :
}

do_install() {
    # Create target directory for installation
    install -d ${D}/home/uthp
    # Copy the uthp-tests directory into the image's /home/uthp
    cp -r ${S}/ ${D}/home/uthp/uthp-tests
    chmod +x ${D}/home/uthp/uthp-tests/core-testing
    chmod +x ${D}/home/uthp/uthp-tests/plc-testing
}

FILES:${PN} = "/home/uthp/uthp-tests"
RDEPENDS:${PN} = "python3-pytest bash perl"