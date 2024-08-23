FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
RDEPENDS:${PN} += "bash"
SRC_URI += "file://init-uthp.sh \
            file://motd \
            file://fstab \
            file://.bashrc \
            file://.bashrc-root \
            file://.bash_profile \
            file://emmc-flasher.sh \
            file://timesyncd.conf \
            file://rpds-py.sh \
            file://default-user-perm.sh \
            "

do_install:append() {
    install -d ${D}${sysconfdir}/profile.d
    install -m 0755 ${WORKDIR}/init-uthp.sh ${D}${sysconfdir}/profile.d/init-uthp.sh
    install -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

    ### This section creates a symlink to support smooth installtion of rpds-py
    # Install the rpds-py.sh script
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/rc3.d
    install -m 0755 ${WORKDIR}/rpds-py.sh ${D}${sysconfdir}/init.d/rpds-py.sh

    # Create a symlink to ensure the script runs at startup
    ln -sf ${sysconfdir}/init.d/rpds-py.sh ${D}${sysconfdir}/rc3.d/S99rpds-py

    ### ends here
    
    #### Change default user permissions
    install -m 0755 ${WORKDIR}/default-user-perm.sh ${D}${sysconfdir}/init.d/default-user-perm.sh
    # Create a symlink to ensure the script runs at startup
    ln -sf ${sysconfdir}/init.d/default-user-perm.sh ${D}${sysconfdir}/rc3.d/S99default-user-perm
    ###


    # testing without -d
    install -d ${D}/home/uthp
    install -d ${D}/root
    install -m 0644 ${WORKDIR}/.bashrc ${D}/home/uthp/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/home/uthp/.bash_profile

    # given that bash is the default shell, we need to install these files for root as well
    install -m 0644 ${WORKDIR}/.bashrc-root ${D}/root/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/root/.bash_profile

    install -d ${D}/opt/scripts
    install -m 0644 ${WORKDIR}/emmc-flasher.sh ${D}/opt/scripts/emmc-flasher.sh

    # need to test rtc with timesyncd
    install -d ${D}${sysconfdir}/systemd/timesyncd.conf.d
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd/timesyncd.conf.d/timesyncd-uthp.conf

    # install the j1939 db
    # install -d ${D}${sysconfdir}/J1939
    # install -m 0644 ${WORKDIR}/J1939db.json ${D}${sysconfdir}/J1939/J1939db.json
}
