DESCRIPTION = "Python module for creation and analysis of binary data"
SECTION = "devel/python"
LICENSE = "CLOSED"

SRC_URI[sha256sum] = "a5848a3f63111785224dca8bb4c0a75b62ecdef56a042c8d6be74b16f7e860e7"

inherit pypi setuptools3

PYPI_PACKAGE = "bitstring"
PYPI_PACKAGE_VERSION = "3.1.9"
SRC_URI = "https://files.pythonhosted.org/packages/source/b/bitstring/${PYPI_PACKAGE}-${PYPI_PACKAGE_VERSION}.tar.gz"

S = "${WORKDIR}/${PYPI_PACKAGE}-${PYPI_PACKAGE_VERSION}"

FILES:${PN} += "${PYTHON_SITEPACKAGES_DIR}/*"