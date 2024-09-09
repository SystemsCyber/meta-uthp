DESCRIPTION = "This is a tool for getting detailed decodings of J1587/J1708 (and J2497) messages using the J1587 and J1708 specification PDFs as a reference"
SECTION = "devel/python"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://${THISDIR}/LICENSE;md5=9cbb8e86b6798efc990e6ac9a33a8b14"

# Specify the source file location
SRC_URI = "git://github.com/ainfosec/pretty_j1587.git;protocol=https;rev=31ac605d1c0dbcf4fde366e278d20382e3617476;branch=master"
SRC_URI[sha256sum] = "7c72341c6e872d9b9e10a681d77a407e8e2cf4e1b88a315e24bd82a938496ad2"

S = "${WORKDIR}/git"

# Assuming the use of poetry or a similar tool as the build backend
inherit setuptools3
RDEPENDS:${PN} += "perl python python3"

do_compile() {
    echo "++++++++++++++++++++++++ No compile necesary"
}

do_install() {
    install -d ${D}/home/uthp/pretty_j1587
    install -m 0755 ${S}/pretty_j1587.py ${D}/home/uthp/pretty_j1587/pretty_j1587.py
    install -m 0755 ${S}/fuzzymessages.py ${D}/home/uthp/pretty_j1587/fuzzymessages.py
    install -m 0644 ${S}/canon_functions.py ${D}/home/uthp/pretty_j1587/canon_functions.py
    install -m 0644 ${S}/config.cfg ${D}/home/uthp/pretty_j1587/config.cfg
    install -m 0644 ${S}/LICENSE ${D}/home/uthp/pretty_j1587/LICENSE
    install -m 0644 ${S}/README.md ${D}/home/uthp/pretty_j1587/README.md
    install -m 0644 ${S}/requirements.txt ${D}/home/uthp/pretty_j1587/requirements.txt
    install -m 0644 ${S}/samplejson.def ${D}/home/uthp/pretty_j1587/samplejson.def
    install -m 0644 ${S}/struct_from_J1587.py ${D}/home/uthp/pretty_j1587/struct_from_J1587.py
    install -m 0644 ${S}/test_pretty_j1587.py ${D}/home/uthp/pretty_j1587/test_pretty_j1587.py
}

FILES:${PN} += "/home/uthp/pretty_j1587/*"