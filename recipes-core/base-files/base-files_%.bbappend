FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://init-uthp.sh \
            file://motd \
            file://fstab \
            file://.bashrc \
            file://.bashrc-root \
            file://.bash_profile \
            file://.nanorc \
            file://emmc-flasher.sh \
            file://timesyncd.conf \
            "

do_install:append() {
    install -d ${D}${sysconfdir}/profile.d
    install -m 0755 ${WORKDIR}/init-uthp.sh ${D}${sysconfdir}/profile.d/init-uthp.sh
    install -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

    # testing without -d
    install -d ${D}/home/uthp
    install -d ${D}/root
    install -m 0644 ${WORKDIR}/.bashrc ${D}/home/uthp/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/home/uthp/.bash_profile
    install -m 0644 ${WORKDIR}/.nanorc ${D}/home/uthp/.nanorc

    # given that bash is the default shell, we need to install these files for root as well
    install -m 0644 ${WORKDIR}/.bashrc-root ${D}/root/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/root/.bash_profile
    install -m 0644 ${WORKDIR}/.nanorc ${D}/root/.nanorc

    install -d ${D}/opt/scripts
    install -m 0644 ${WORKDIR}/emmc-flasher.sh ${D}/opt/scripts/emmc-flasher.sh

    # need to test rtc with timesyncd
    install -d ${D}${sysconfdir}/systemd/timesyncd.conf.d
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd/timesyncd.conf.d/timesyncd-uthp.conf

    # install the j1939 db
    # install -d ${D}${sysconfdir}/J1939
    # install -m 0644 ${WORKDIR}/J1939db.json ${D}${sysconfdir}/J1939/J1939db.json
}
