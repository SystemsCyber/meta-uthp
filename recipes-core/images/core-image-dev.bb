# Note: this is a devlopment image, not a production image. It is intended for development and testing purposes only.
SUMMARY = "UTHP Core Image Recipe"
DESCRIPTION = "A core image recipe for the UTHP project"
LICENSE = "MIT"

INHERIT += "cve-check"

# poky/core-image.bbclass
inherit core-image

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

IMAGE_INSTALL = " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

# The rootfs size is 2.8GB which is adjusted dynamically by bitbake
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
    uthp-tests \
 "

KERNEL_EXTRA_INSTALL = " \
    kernel-dev \
    kernel-modules \
    linux-libc-headers-dev \
    kernel-devsrc \
    uthp-devicetrees \
 "

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
    ti-cgt-pru \
    screen \
 "

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
    python3-platformdirs \
    python3-click \
    python3-rpds-py \
    python3-pytest \
 "

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
# let's at least make sure the pre-production image has some security... generate a password hash for 'root' using our quick script generate-preproduction-password.sh
HASH_PASS = "\$6\$fJxcAKMWA84wS4sT\$BF5XVhI6eyEvu7w3k8D8lPRttzMiY72qloPOolJo1pv7siU1Vsa49IqBtf6JUNvZ.Acz0WCYLLLWPFF0ehJDg/"
EXTRA_USERS_PARAMS = " \
    usermod -s /bin/bash root; \
    usermod -p '${HASH_PASS}' root; \
    passwd-expire root; \
	"

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers;"