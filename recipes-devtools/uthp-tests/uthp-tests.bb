SUMMARY = "UTHP Tests"
DESCRIPTION = "This recipe provides the UTHP tests."
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://test_cmap.py \
            "

do_install() {
    install -d ${D}/home/uthp/uthp-tests
    for file in ${WORKDIR}/*.py; do
        install -m 755 "$file" ${D}/home/uthp/uthp-tests
    done
}

FILES:${PN} = "/home/uthp/uthp-tests"

RDEPENDS:${PN} = "python3-pytest"