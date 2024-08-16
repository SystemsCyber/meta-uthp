#!/bin/bash

YOCTO_DIR="Yocto"

# Error handling function
function handle_error() {
    echo "Error on line $1"
    exit 1
}

# Helper functions for setting up the Yocto development environment
function clone_and_checkout() {
    echo -e "\n==> Cloning and checking out layers...\n"

    # Clone and checkout poky if the directory does not exist or the directory is empty
    if [ ! -d "$FULL_YOCTO_DIR/" ] || [ -z "$(ls -A $FULL_YOCTO_DIR/)" ]; then
        git clone git://git.yoctoproject.org/poky.git "$FULL_YOCTO_DIR/" || handle_error $LINENO
        cd "$FULL_YOCTO_DIR/" || handle_error $LINENO
        git checkout scarthgap || handle_error $LINENO
        pwd || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/ already exists, skipping clone."
    fi

    # Clone and checkout meta-openembedded
    if [ ! -d "$FULL_YOCTO_DIR/meta-openembedded" ]; then
        git clone git://git.openembedded.org/meta-openembedded "$FULL_YOCTO_DIR/meta-openembedded" || handle_error $LINENO
        cd "$FULL_YOCTO_DIR/meta-openembedded" || handle_error $LINENO
        git checkout scarthgap || handle_error $LINENO
        cd "$FULL_YOCTO_DIR" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-openembedded already exists, skipping clone."
    fi

    # Clone meta-python2
    if [ ! -d "$FULL_YOCTO_DIR/meta-python2" ]; then
        git clone git://git.openembedded.org/meta-python2 "$FULL_YOCTO_DIR/meta-python2" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-python2 already exists, skipping clone."
    fi

    # Clone meta-jupyter
    if [ ! -d "$FULL_YOCTO_DIR/meta-jupyter" ]; then
        git clone https://github.com/Xilinx/meta-jupyter "$FULL_YOCTO_DIR/meta-jupyter" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-jupyter already exists, skipping clone."
    fi

    # Clone and checkout meta-arm
    if [ ! -d "$FULL_YOCTO_DIR/meta-arm" ]; then
        git clone git://git.yoctoproject.org/meta-arm "$FULL_YOCTO_DIR/meta-arm" || handle_error $LINENO
        cd "$FULL_YOCTO_DIR/meta-arm" || handle_error $LINENO
        git checkout scarthgap || handle_error $LINENO
        cd "$FULL_YOCTO_DIR" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-arm already exists, skipping clone."
    fi

    # Clone and checkout meta-ti
    if [ ! -d "$FULL_YOCTO_DIR/meta-ti" ]; then
        git clone git://git.yoctoproject.org/meta-ti "$FULL_YOCTO_DIR/meta-ti" || handle_error $LINENO
        cd "$FULL_YOCTO_DIR/meta-ti" || handle_error $LINENO
        git checkout scarthgap || handle_error $LINENO
        cd "$FULL_YOCTO_DIR" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-ti already exists, skipping clone."
    fi

    # Clone and checkout meta-uthp
    if [ ! -d "$FULL_YOCTO_DIR/meta-uthp" ]; then
        git clone https://github.com/SystemsCyber/meta-uthp "$FULL_YOCTO_DIR/meta-uthp" || handle_error $LINENO
        cd "$FULL_YOCTO_DIR/meta-uthp" || handle_error $LINENO
        git checkout scarthgap || handle_error $LINENO
        cd "$FULL_YOCTO_DIR" || handle_error $LINENO
    else
        echo "Directory $FULL_YOCTO_DIR/meta-uthp already exists, skipping clone."
    fi

    echo "Cloning and checking out completed. Now working on meta-jupyter and meta-python2."
}

echo -e "\n==>Installing necessary packages...\n"
# 1. setup build host
sudo apt install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint xterm python3-subunit mesa-common-dev zstd liblz4-tool || handle_error $LINENO
echo -e "\n==> Package installation completed.\n"

# 2. Clone the Yocto layers
mkdir -p "$YOCTO_DIR" || handle_error $LINENO
FULL_YOCTO_DIR=$(cd "$YOCTO_DIR" && pwd) || handle_error $LINENO
echo -e "\n==> Yocto development directory located at: $FULL_YOCTO_DIR\n"
clone_and_checkout

# Add the meta-uthp conf.samples to their respective directories
echo -e "\n==>Copying layer configuration files from the meta-uthp repo...\n"
source "$FULL_YOCTO_DIR/oe-init-build-env" || handle_error $LINENO
cd "$FULL_YOCTO_DIR" || handle_error $LINENO
cp "$FULL_YOCTO_DIR/meta-uthp/conf.samples/meta-python2-layer.conf.sample" "$FULL_YOCTO_DIR/meta-python2/conf/layer.conf" || handle_error $LINENO
cp "$FULL_YOCTO_DIR/meta-uthp/conf.samples/meta-jupyter-layer.conf.sample" "$FULL_YOCTO_DIR/meta-jupyter/conf/layer.conf" || handle_error $LINENO
cp "$FULL_YOCTO_DIR/meta-uthp/conf.samples/local.conf.sample" "$FULL_YOCTO_DIR/build/conf/local.conf" || handle_error $LINENO
cp "$FULL_YOCTO_DIR/meta-uthp/conf.samples/bblayers.conf.sample" "$FULL_YOCTO_DIR/build/conf/bblayers.conf" || handle_error $LINENO
cp "$FULL_YOCTO_DIR/meta-uthp/conf.samples/conf-notes.txt" "$FULL_YOCTO_DIR/build/conf/conf-notes.txt" || handle_error $LINENO
for file in $FULL_YOCTO_DIR/build/conf/*; do sed -i "s#\${FULL_YOCTO_DIR}#$(pwd)#g" "$file"; done
echo "Configuration files copied."