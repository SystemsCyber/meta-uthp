SUMMARY = "Python bindings to the Rust rpds crate for persistent data structures."
HOMEPAGE = "https://pypi.org/project/rpds-py/"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7767fa537c4596c54141f32882c4a984"

SRC_URI += "file://run-ptest"

SRC_URI[sha256sum] = "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"

require ${BPN}-crates.inc

inherit pypi cargo-update-recipe-crates python_maturin

PYPI_PACKAGE = "rpds_py"

BBCLASSEXTEND = "native nativesdk"