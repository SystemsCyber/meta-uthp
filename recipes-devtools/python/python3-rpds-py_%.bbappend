# Append to do_install task
do_install:append() {
    SITE_PACKAGES_DIR="${D}${libdir}/python3.12/site-packages/rpds"
    
    # Create the symbolic link with a relative path to avoid referencing TMPDIR
    ln -sf rpds.cpython-312-armv7l-linux-gnueabihf.so ${SITE_PACKAGES_DIR}/rpds.so
}

FILES:${PN}-dev += "${libdir}/python3.12/site-packages/rpds/rpds.so"