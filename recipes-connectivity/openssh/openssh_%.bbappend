FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-NOROOTPASS.patch"
# this file gets indirectly called by the openssh recipe used by the core-image recipe for the UTHP project
# TODO: apparently this file is not being called by the openssh recipe...