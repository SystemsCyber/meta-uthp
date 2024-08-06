SUMMARY = "Useradd for UTHP"
DESCRIPTION = "This recipe sets up users and groups for UTHP"
SECTION = "core"
LICENSE = "CLOSED"

S = "${WORKDIR}"

EXCLUDE_FROM_WORLD = "1"

inherit useradd
# You must set USERADD_PACKAGES when you inherit useradd. This
# lists which output packages will include the user/group
# creation code.
USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "\
	-s /bin/bash -p '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0' -d /home/uthp uthp; \
	-s /bin/bash -p '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0' root; \
	"

do_install () {
	# install and modify home directory
	install -d -m 755 ${D}/home/uthp
	chown -R uthp ${D}/home/uthp
	chgrp -R uthp ${D}/home/uthp
}

FILES:${PN} = "*"

# Prevents do_package failures with:
# debugsources.list: No such file or directory:
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

