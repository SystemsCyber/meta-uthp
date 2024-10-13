DESCRIPTION = "Useful in interacting with trucks that use J1939"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${THISDIR}/LICENSE;md5=9cbb8e86b6798efc990e6ac9a33a8b14"

# Specify the source file location
SRC_URI = "git://github.com/LittleBlondeDevil/TruckDevil.git;protocol=https;rev=c3485b3cedfe458fdb22c58334a48b863d889d07;branch=master"
SRC_URI[sha256sum] = "7c72341c6e872d9b9e10a681d77a407e8e2cf4e1b88a315e24bd82a938496ad2"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://.env"

S = "${WORKDIR}/git"

# install full TruckDevil package in /home/uthp
do_install() {
    install -d ${D}/opt/uthp/programs
    install -d ${D}/usr/bin

    cp -r ${S}/truckdevil ${D}/opt/uthp/programs
    install -m 0755 ${WORKDIR}/.env ${D}/opt/uthp/programs/truckdevil

    # links to a environment file that runs the program
    ln -s /opt/uthp/programs/truckdevil/.env ${D}/usr/bin/truckdevil

    # Make the script executable after we copied everything over
    chmod +x ${D}/opt/uthp/programs/truckdevil/truckdevil.py
}


# Quickly edit the shebang line
do_compile() {
    sed -i '1i #!/usr/bin/python3' ${S}/truckdevil/truckdevil.py
}

RDEPENDS:${PN} += "python3-core python3 bash"
FILES:${PN} += "/opt/uthp/programs/truckdevil \
                /usr/bin/truckdevil"