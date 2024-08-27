DESCRIPTION = "ISO-TP CAN kernel module"
LICENSE = "CLOSED"
# LIC_FILES_CHKSUM = "file://COPYING;md5=bf5544e451fb1469f6d20dcfdb87394a"

SRC_URI = "git://github.com/hartkopp/can-isotp.git;branch=master"
SRCREV = "7626d0a0707391970080d493ce69638719938da7"

S = "${WORKDIR}/git"

inherit module

EXTRA_OEMAKE = ""

# Install the module
do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra
    install -m 0644 net/can/can-isotp.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
}

do_compile() {
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    make -C ${STAGING_KERNEL_DIR} M=${S} modules
}

# Ensure the module gets picked up in the final image
depmod_postinst() {
    depmod -a ${KERNEL_VERSION}
}

# Mark as machine-specific since it is a kernel module
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES:${PN} = "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/can-isotp.ko"