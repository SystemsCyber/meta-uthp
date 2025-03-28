DESCRIPTION = "Python module for CAN bus hacking utilities, installs can2 into libsigrokdecode"
HOMEPAGE = "https://github.com/kentindell/canhack"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git-src/LICENSE;md5=8310311119912ce8b370b7ad60cc450c"

SRC_URI = "git://github.com/kentindell/canhack.git;protocol=https;branch=master;destsuffix=git-src"
SRCREV = "e0c3a3da14969a8a7a3c8da817aaf66b3bfb7c04"

S = "${WORKDIR}/git-src/src"

do_install() {
    # Target directory within the root filesystem
    targetdir="${D}/usr/share/libsigrokdecode/decoders/"

    # Ensure the target directory exists
    install -d ${targetdir}

    # Copy the entire can2 directory
    cp -r ${S}/can2 ${targetdir}
}

FILES:${PN} += "/usr/share/libsigrokdecode"
