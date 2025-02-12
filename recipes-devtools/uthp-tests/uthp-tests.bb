SUMMARY = "UTHP Tests"
DESCRIPTION = "This recipe provides the UTHP tests."
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://pytest.ini \
            file://Makefile \
            file://setup4testing.sh \
            file://test_cmap.py \
            file://test_cancat.py \
            file://test_python_can_j1939.py \
            file://test_scapy_automotive.py \
            file://test_truckdevil.py \
            file://test_pretty_j1939.py \
            file://test_py_hv_networks.py \
            file://test_sigrok-cli.py \
            "

do_install() {
    install -d ${D}/home/uthp/uthp-tests
    for file in ${WORKDIR}/*.py; do
        install -m 755 "$file" ${D}/home/uthp/uthp-tests
    done
    install -m 755 ${WORKDIR}/pytest.ini ${D}/home/uthp/uthp-tests

    # install Makefile and setup4testing.sh for physical env testing
    install -m 755 ${WORKDIR}/Makefile ${D}/home/uthp
    install -m 755 ${WORKDIR}/setup4testing.sh ${D}/home/uthp

}

FILES:${PN} = "/home/uthp/uthp-tests"

RDEPENDS:${PN} = "python3-pytest"