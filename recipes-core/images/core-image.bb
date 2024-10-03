SUMMARY = "UTHP Core Image Recipe"
DESCRIPTION = "A core image recipe for the UTHP project"
LICENSE = "MIT"

INHERIT += "cve-check"

inherit core-image

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

IMAGE_INSTALL = " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

# The rootfs size is 2.7GB which is adjust dynamically by bitbake
IMAGE_ROOTFS_SIZE = "2797152"

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    sudo \
    libgpiod libgpiod-tools libgpiod-dev \
    usbutils usb-gadget usb0-dhcp \
    safe-shutdown \
    locale-base-en-us \
    locale-base-en-gb \
    uthp-serial-services \
    uthp-tcp-services \
 "

KERNEL_EXTRA_INSTALL = " \
    kernel-dev \
    kernel-modules \
    linux-libc-headers-dev \
    kernel-devsrc \
    uthp-devicetrees \
 "
# deleted vcan0

DEV_SDK_INSTALL = " \
    binutils \
    binutils-symlinks \
    coreutils \
    cpp \
    cpp-symlinks \
    diffutils \
    file \
    gcc \
    gcc-symlinks \
    g++ \
    g++-symlinks \
    gettext \
    git \
    ldd \
    libstdc++ \
    libstdc++-dev \
    libtool \
    make \
    perl-modules \
    pkgconfig \
    bbb-pin-utils \
    tzdata \
    libxml2-dev \
    libnl \
    libnl-dev \
    pru-icss \
    ti-cgt-pru \
    screen \
 "
# need rsync to get the files from the host to the target for apt-keys at least

EXTRA_TOOLS_INSTALL = " \
    bc \
    bzip2 \
    devmem2 \
    dosfstools \
    e2fsprogs \
    ethtool \
    findutils \
    i2c-tools \
    iftop \
    htop \
    less \
    nano \
    procps \
    rtl-sdr \
    sysfsutils \
    tmux \
    unzip \
    util-linux \
    wget \
    zip \
    tar \
    tcpdump \
    vim \
    xxd \
    rsync \
    u-boot-tools \
    apt-setup \
    gnupg \
    man-pages \
    man-db \
    tree \
    ncurses \
    curl \
 "

# FIXME: missing man command

CAN_TOOLS = " \
    can-utils \
    libsocketcan \
    libsocketcan-dev \
    iproute2 \
    sigrok-cli \
    can2 \
    truckdevil \
    cannelloni \
    cannelloni-server \
 "
# deleted config-pin
PREFERRED_VERSION_python = "2.7"
PYTHON_TOOLS = " \
    python \
    python-modules \
    python-importlib-metadata \
    python-enum34 \
    python-six \
    python-attrs \
    python-typing \
 "

# FIXME: scapy six issues?
PYTHON3_TOOLS = " \
    python3 \
    python3-core \
    python3-setuptools \
    python3-pip \
    packagegroup-python3-jupyter \
    python3-scapy \
    python3-can \
    python3-cmap \
    python3-cantools \
    python3-six \
    python3-cancat \
    python3-canmatrix \
    python3-future \
    python3-sae-j1939 \
    python3-jsonschema \
    python3-termcolor \
    python3-attrs \
    python3-pyserial \
    python3-typing-extensions \
    python3-dev \
    python3-asyncio-glib \
    python3-dill \
    python3-bitstring \
    python3-pretty-j1939 \
    python3-pretty-j1587 \
    python3-py-hv-networks \
    plc4trucksduck \
    python3-can-isotp \
    python3-inputtimeout \
 "

# TODO:

## Tools we still need to add / test
# python3-pretty-j1939 --> add json files dynamically from our local storage
# python3-pretty-j1587 --> add json files dynamically from our local storage
# plc4trucksduck --> Test the firmware on the Yocto distro
# python3-py-hv-networks
# cmap
# cannelloni-server

## Tools we need to port
# CanCat --> needs to be ported to SocketCAN

## Tools we need to expose over serial
# Expose CanCat encoding for use by CanCat
# Expose GRIMMs j1708 encoding for use by GRIMMs tools
# Exopose Truck Devil 'serial stuff' for use by Truck Devil

## Tools we need to expose over TCP/UDP
# Expose the py-hv-networks j1708 udp server (already done pretty much)
# Expose M2 CAN encoding over TCP socket and add Truck Devil 'serial stuff'
# Expose CanCat encoding over TCP socket and add TCP support to CanCat
# Expose GRIMMs j1708 encoding over TCP socket and add TCP supprot to GRIMMs tools

## jupyter lab
# python3-rpds-py \ --> needs to be v0.2.0???

## core image
# (check the fix-uthp script under base-files)
# actually add license files to recipes to be compliant

## interesting tools we should add
# https://github.com/coder/code-server/


IMAGE_INSTALL += " \
    ${CAN_TOOLS} \
    ${CORE_OS} \
    ${DEV_SDK_INSTALL} \
    ${EXTRA_TOOLS_INSTALL} \
    ${KERNEL_EXTRA_INSTALL} \
    ${PYTHON_TOOLS} \
    ${PYTHON3_TOOLS} \
 "

update_sudoers(){
    sed -i 's/# %sudo/%sudo/' ${IMAGE_ROOTFS}/etc/sudoers
}

inherit extrausers
PASS = '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0'
EXTRA_USERS_PARAMS = " \
    useradd -u 1000 -d /home/uthp -s /bin/bash -p '${PASS}' uthp; \
    usermod -aG sudo uthp; \
	passwd-expire uthp; \
    usermod -s /bin/bash root; \
    usermod -p '${PASS}' root; \
	passwd-expire root; \
	"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"