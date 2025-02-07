SUMMARY = "UTHP Tests"
DESCRIPTION = "This recipe provides the UTHP tests."
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://pytest.ini \
            file://test_cmap.py \
            file://test_cancat.py \
            file://test_python_can_j1939.py \
            file://test_scapy_automotive.py \
            file://test_truckdevil.py \
            "

do_install() {
    install -d ${D}/home/uthp/uthp-tests
    for file in ${WORKDIR}/*.py; do
        install -m 755 "$file" ${D}/home/uthp/uthp-tests
    done
    install -m 755 ${WORKDIR}/pytest.ini ${D}/home/uthp/uthp-tests
}

FILES:${PN} = "/home/uthp/uthp-tests"

RDEPENDS:${PN} = "python3-pytest"