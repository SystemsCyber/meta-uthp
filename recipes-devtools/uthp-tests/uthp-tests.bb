SUMMARY = "UTHP Tests"
DESCRIPTION = "This recipe provides the UTHP tests."
LICENSE = "CLOSED"

SRC_URI = "file://uthp-tests"

# Set the source directory (defaults to WORKDIR after unpacking)
S = "${WORKDIR}"

do_install() {
    # Create target directory for installation
    install -d ${D}/home/uthp
    # Copy the uthp-tests directory into the image's /home/uthp
    cp -r ${S}/uthp-tests ${D}/home/uthp/
}

FILES:${PN} = "/home/uthp/uthp-tests"
RDEPENDS:${PN} = "python3-pytest"