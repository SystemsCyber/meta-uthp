DESCRIPTION = "The package provides SAE J1939 support for Python developers"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${THISDIR}/LICENSE;md5=9cbb8e86b6798efc990e6ac9a33a8b14"

SRC_URI = "git://github.com/juergenH87/python-can-j1939.git;protocol=https;rev=df8f694aefa9581428d9d70cceff6c05df890fcb;branch=master"
SRC_URI[sha256sum] = "7c72341c6e872d9b9e10a681d77a407e8e2cf4e1b88a315e24bd82a938496ad2"

S = "${WORKDIR}/git"

# Assuming the use of poetry or a similar tool as the build backend
inherit setuptools3

#do_compile() {
#    # Build the package using the backend specified in pyproject.toml
#    # This command depends on the build system used by the package
#    #oe_runmake # or custom build command, e.g., poetry build
#    echo "++++++++++++++++++++++++ No compile necesary"
#}

#do_install() {
#    # Install the package into the appropriate location
#    # Adjust these commands based on the actual build backend and file structure
#    install -d ${D}${libdir}/python${PYTHON_BASEVERSION}/site-packages/cmap
#    cp -r ${S}/src/cmap ${D}${libdir}/python${PYTHON_BASEVERSION}/site-packages/cmap
#    # Repeat for other directories and files as necessary
#}


