SUMMARY = "UTHP Core Image Recipe"
DESCRIPTION = "A core image recipe for the UTHP project"
LICENSE = "MIT"

inherit core-image

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

IMAGE_INSTALL = " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

# The rootfs size is 2.7GB which is adjust dynamically by bitbake
IMAGE_ROOTFS_SIZE = "2797152"

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    sudo useradd-uthp \
    libgpiod libgpiod-tools libgpiod-dev \
    usbutils \
    safe-shutdown \
    locale-base-en-us \
    locale-base-en-gb \
 "

KERNEL_EXTRA_INSTALL = " \
    kernel-modules \
    kernel-devsrc \
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
    python3-bitstring \
    python3-jupyterlab \
    python3-rpds-py \
    python3-psutil \
    python3-scapy \
    python3-can \
    python3-cantools \
    python3-six \
    python3-cancat \
    python3-canmatrix \
    python3-future \
    python3-sae-j1939 \
    python3-jsonschema \
    python3-nest-asyncio \
    python3-numpy \
    python3-pyserial \
    python3-termcolor \
    python3-attrs \
    python3-typing-extensions \
    python3-flask \
    python3-websockets \
    python3-dev \
    python3-asyncio-glib \
    python3-dill \
 "
# TODO:
# python3-pretty-j1939 
# python3-pretty-j1587
# plc4trucksduck
# python3-py-hv-networks

IMAGE_INSTALL += " \
    ${CAN_TOOLS} \
    ${CORE_OS} \
    ${DEV_SDK_INSTALL} \
    ${EXTRA_TOOLS_INSTALL} \
    ${KERNEL_EXTRA_INSTALL} \
    ${PYTHON_TOOLS} \
    ${PYTHON3_TOOLS} \
 "

inherit extrausers
PASS = '\$6\$kXDp5Q1Ki1mAOJ7U\$Bz7DjUHuRjnO/oPL6Xc3/TOiknek/eXiXIL8wiU00VpNJmd9dMayr6RvsY5Ip9DZ7Q9CAZEhFIKAgYRJf8ZgV0'
EXTRA_USERS_PARAMS = " \
    usermod -aG sudo uthp; \
	passwd-expire uthp; \
    usermod -s /bin/bash root; \
    usermod -p ${PASS} root; \
	passwd-expire root; \
	"

update_sudoers(){
    sed -i 's/# %sudo/%sudo/' ${IMAGE_ROOTFS}/etc/sudoers
}

ROOTFS_POSTPROCESS_COMMAND += "update_sudoers"