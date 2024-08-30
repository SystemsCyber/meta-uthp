SUMMARY = "An implementation of the Debug Adapter Protocol for Python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7b6b095fe2a2e2b66cb08d295b605789"

PYPI_SRC_URI="https://files.pythonhosted.org/packages/b2/c9/9d585d711cdcae0db7788731b331dab0d1f600d0204e76b2a5c6b30d569e/debugpy-1.8.2.zip"
SRC_URI[sha256sum] = "95378ed08ed2089221896b9b3a8d021e642c24edc8fef20e5d4342ca8be65c00"

PYPI_PACKAGE = "debugpy"

inherit pypi setuptools3

BBCLASSEXTEND = "native"