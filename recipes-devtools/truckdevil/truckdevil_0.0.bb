# TODO: update this with TCP enabled truckdevil
DESCRIPTION = "Useful in interacting with trucks that use J1939"
SECTION = "devel/python"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE.md;md5=1ebbd3e34237af26da5dc08a4e440464"

# using the TCP version of TruckDevil
SRC_URI = "git://github.com/Spenc3rB/TruckDevil.git;protocol=https;rev=95f4aadbe394bbac62d1a5009c97a119768e5c7f;branch=master"

S = "${WORKDIR}/git"
SRC_URI += "file://truckdevil"

# install full TruckDevil package in /home/uthp
do_install() {
    install -d ${D}/opt/uthp/programs
    install -d ${D}/usr/bin

    cp -r ${S}/truckdevil ${D}/opt/uthp/programs

    # Make the script executable after we copied everything over
    chmod +x ${D}/opt/uthp/programs/truckdevil/truckdevil.py

    # Add the truckdevil wrapper
    install -m 0755 ${WORKDIR}/truckdevil ${D}/usr/bin/truckdevil
}


# Quickly edit the shebang line
do_compile() {
    sed -i '1i #!/usr/bin/python3' ${S}/truckdevil/truckdevil.py
}

RDEPENDS:${PN} += "python3-core python3 bash"
FILES:${PN} += "/opt/uthp/programs/truckdevil \
                /usr/bin/truckdevil \
                "