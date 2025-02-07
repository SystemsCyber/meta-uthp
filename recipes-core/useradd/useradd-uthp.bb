SUMMARY = "Useradd for UTHP"
DESCRIPTION = "Sets up users and groups for the UTHP"
SECTION = "core"
LICENSE = "CLOSED"
S = "${WORKDIR}"

EXCLUDE_FROM_WORLD = "1"

inherit useradd 
USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "-u 1000 -d /home/uthp -s /bin/bash -g uthp uthp"
GROUPADD_PARAM:${PN} = "-g 1000 uthp"

do_install() {
    install -d -m 0755 ${D}/home/uthp
    chown -R 1000:1000 ${D}/home/uthp

    install -d -m 0755 ${D}/etc/sudoers.d
    # password require uthp for sudo access
    echo "uthp ALL=(ALL) ALL" > ${D}/etc/sudoers.d/uthp  
    chmod 0440 ${D}/etc/sudoers.d/uthp
}

# pass can be generated using the generate-preproduction-password.sh script in the root of the meta-uthp layer
HASHED_PASS = "\$6\$52h9WGoI47tJo0sD\$XHs5zsjQwknfDQqQKj8tHXWdDytLkzX7ewsdtACxkMI0AEH17Cqd.V./v7kdHbmzAxl/vR.MI8AC1Remi6mwY."

inherit extrausers
# below we set the root shell to bash, and set the password for the uthp user/expires it
# TODO: figure out openssh no permit login issue; maybe lock root account if needed
EXTRA_USERS_PARAMS = "  usermod -s /bin/bash root; \
                        usermod -p '${HASHED_PASS}' uthp; \
                        passwd-expire uthp; \
                        "

FILES:${PN} = "/home/uthp /etc/sudoers.d/uthp"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

RDEPENDS:${PN} = "bash sudo"