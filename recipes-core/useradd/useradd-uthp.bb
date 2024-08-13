SUMMARY = "Useradd for UTHP"
DESCRIPTION = "Sets up users and groups for the UTHP"
SECTION = "core"
LICENSE = "CLOSED"

S = "${WORKDIR}"

EXCLUDE_FROM_WORLD = "1"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "-s /bin/bash -p '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0' -g uthp -G uthp uthp"
GROUPADD_PARAM:${PN} = "--system uthp"

do_install () {
    # Install and set permissions for the home directory
    install -d -m 755 ${D}/home/uthp
    chown -R uthp:uthp ${D}/home/uthp
}

FILES:${PN} = "/home/uthp"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"