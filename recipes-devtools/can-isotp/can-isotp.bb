SUMMARY = "ISO-TP kernel module for CAN protocol"
DESCRIPTION = "A kernel module that provides ISO-TP (ISO 15765-2) protocol support for CAN networks."
LICENSE = "CLOSED"
SRC_URI = "https://github.com/hartkopp/can-isotp;protocol=https"
SRC_URI[sha256sum] = "d639e100402cb08dd1b87b4917242675b4f7329624e8b6d82438cefa109744d5"
SRCREV = "mainline-5.4+"

DEPENDS = "virtual/kernel"

# Set the kernel module package
inherit module

S = "${WORKDIR}/git/net/can"

# Install headers and tools necessary to build the kernel module
do_compile() {
    # unset environment variables just in case
    oe_runmake
}

do_install() {
    oe_runmake DESTDIR=${D} modules_install
}

# Additional package configuration
FILES:${PN} += "${libdir}/modules/${KERNEL_VERSION}/extra/can-isotp.ko"
RPROVIDES:${PN} = "kernel-module-can-isotp"
