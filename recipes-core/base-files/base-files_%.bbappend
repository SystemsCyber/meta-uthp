FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "/storage/standards:"
SRC_URI += "file://init-uthp.sh \
            file://fstab \
            file://.bashrc \
            file://.bashrc-root \
            file://.bash_profile \
            file://.nanorc \
            file://emmc-flasher \
            file://timesyncd.conf \
            file://J1939db.json \
            file://J1708_201609.pdf.txt \
            file://J1587_201301.pdf.txt \
            file://rpds-py.sh \
            file://update-time \
            file://check-uthp \
            file://check-baud \
            file://sigrok-firmware-installer \
            "

do_install:append() {

    # Profile setups
    install -d ${D}${sysconfdir}/profile.d
    install -m 0755 ${WORKDIR}/init-uthp.sh ${D}${sysconfdir}/profile.d/init-uthp.sh

    # fstab
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab

    ### This section creates a symlink to support smooth installtion of rpds-py (hacky way) and the uthp user perms
    # Install the rpds-py.sh script
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/rc3.d
    install -m 0755 ${WORKDIR}/rpds-py.sh ${D}${sysconfdir}/init.d/rpds-py.sh
    install -m 0755 ${WORKDIR}/check-uthp ${D}${sysconfdir}/init.d/check-uthp
    install -m 0755 ${WORKDIR}/check-baud ${D}${sysconfdir}/init.d/check-baud

    # Create a symlink to ensure the script runs at startup
    ln -sf ${sysconfdir}/init.d/rpds-py.sh ${D}${sysconfdir}/rc3.d/S99rpds-py
    ln -sf ${sysconfdir}/init.d/check-uthp ${D}${sysconfdir}/rc3.d/S99check-uthp
    ln -sf ${sysconfdir}/init.d/check-baud ${D}${sysconfdir}/rc3.d/S99check-baud
    ### ends here

    ### script to set the time and timezone
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/update-time ${D}/usr/bin/update-time
    install -m 0755 ${WORKDIR}/sigrok-firmware-installer ${D}/usr/bin/sigrok-firmware-installer

    # user setups
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
}

RDEPENDS:${PN} += "bash python3 python3-core python3-pyserial"