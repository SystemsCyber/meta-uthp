## FIXME: useradd needs to set the correct permissions for the user uthp
SUMMARY = "Useradd for UTHP"
DESCRIPTION = "Sets up users and groups for the UTHP"
SECTION = "core"
LICENSE = "CLOSED"
S = "${WORKDIR}"

EXCLUDE_FROM_WORLD = "1"

inherit useradd

USERADD_PACKAGES = "${PN}"

PASS = '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0'

USERADD_PARAM:${PN} = "-u 1000 -d /home/uthp -s /bin/bash -p ${PASS} -g uthp uthp"
GROUPADD_PARAM:${PN} = "-g 1000 uthp"

do_install() {
    install -d -m 0755 ${D}/home/uthp
    chown uthp:uthp ${D}/home/uthp
}

FILES:${PN} = "/home/uthp"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

# Ensure bash is available
RDEPENDS:${PN} = "bash"