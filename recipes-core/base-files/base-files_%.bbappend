FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "/storage/standards:"
SRC_URI += "file://init-uthp.sh \
            file://motd \
            file://fstab \
            file://.bashrc \
            file://.bashrc-root \
            file://.bash_profile \
            file://.nanorc \
            file://emmc-flasher \
            file://timesyncd.conf \
            file://fix-uthp \
            file://J1939db.json \
            file://J1708_201609.pdf.txt \
            file://J1587_201301.pdf.txt \
            "

do_install:append() {

    # Profile setups
    install -d ${D}${sysconfdir}/profile.d
    install -m 0755 ${WORKDIR}/init-uthp.sh ${D}${sysconfdir}/profile.d/init-uthp.sh
    install -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

    install -d ${D}/home/uthp
    install -d ${D}/root
    install -m 0644 ${WORKDIR}/.bashrc ${D}/home/uthp/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/home/uthp/.bash_profile
    install -m 0644 ${WORKDIR}/.nanorc ${D}/home/uthp/.nanorc

    # standards
    install -d ${D}/opt/uthp/J1939
    install -m 0644 ${WORKDIR}/J1939db.json ${D}/opt/uthp/J1939/J1939db.json
    install -d ${D}/opt/uthp/J1708
    install -m 0644 ${WORKDIR}/J1708_201609.pdf.txt ${D}/opt/uthp/J1708/J1708_201609.pdf.txt
    install -d ${D}/opt/uthp/J1587
    install -m 0644 ${WORKDIR}/J1587_201301.pdf.txt ${D}/opt/uthp/J1587/J1587_201301.pdf.txt

    # given that bash is the default shell, we need to install these files for root as well
    install -m 0644 ${WORKDIR}/.bashrc-root ${D}/root/.bashrc
    install -m 0644 ${WORKDIR}/.bash_profile ${D}/root/.bash_profile
    install -m 0644 ${WORKDIR}/.nanorc ${D}/root/.nanorc

    # setup the mmc flasher script
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/emmc-flasher ${D}/usr/bin/emmc-flasher

    # need to test rtc with timesyncd
    install -d ${D}${sysconfdir}/systemd/timesyncd.conf.d
    install -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd/timesyncd.conf.d/timesyncd-uthp.conf

    # install the fix-uthp script
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/fix-uthp ${D}/usr/bin/fix-uthp
}

RDEPENDS:${PN} += "bash python3 python3-core python3-pyserial"