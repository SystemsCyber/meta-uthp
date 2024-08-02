FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://BB-UTHP-DCAN.dtbo \
            file://MCP251xFD-SPI.dtbo"
LICENSE = "CLOSED"
FILES:${PN} += "*"

inherit deploy
# DEPLOY_DIR_IMAGE="/storage/spencer/Yocto/build/deploy-ti/images/uthp"
do_deploy(){
    install -d ${DEPLOYDIR}/dtbo
    install -m 0644 ${WORKDIR}/BB-UTHP-DCAN.dtbo ${DEPLOYDIR}/dtbo
    install -m 0644 ${WORKDIR}/MCP251xFD-SPI.dtbo ${DEPLOYDIR}/dtbo
}

addtask do_deploy after do_compile