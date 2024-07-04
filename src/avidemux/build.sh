#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-fomit-frame-pointer -fPIC -D__MUSL__"
export CXXFLAGS="$CFLAGS -Wno-narrowing -Wno-reserved-user-defined-literal"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

function log {
    echo ">>> $*"
}

AVIDEMUX_URL="${1:-}"
OPENCORE_AMR_URL="${2:-}"
TWOLAME_URL="${3:-}"
AFTEN_URL="${4:-}"
LIBDCA_URL="${5:-}"
DCAENC_URL="${6:-}"

if [ -z "$AVIDEMUX_URL" ]; then
    log "ERROR: Avidemux URL missing."
    exit 1
fi

if [ -z "$OPENCORE_AMR_URL" ]; then
    log "ERROR: opencore-amr URL missing."
    exit 1
fi

if [ -z "$TWOLAME_URL" ]; then
    log "ERROR: TwoLame URL missing."
    exit 1
fi

if [ -z "$AFTEN_URL" ]; then
    log "ERROR: Aften URL missing."
    exit 1
fi

if [ -z "$LIBDCA_URL" ]; then
    log "ERROR: libdca URL missing."
    exit 1
fi

if [ -z "$DCAENC_URL" ]; then
    log "ERROR: dcaenc URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    bash \
    binutils \
    coreutils \
    clang \
    llvm \
    llvm-dev \
    make \
    cmake \
    pkgconf \
    autoconf \
    automake \
    libtool \
    yasm \
    nasm \
    patch \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
    file \
    qt5-qtbase \
    qt5-qttools-dev \
    zlib-dev \
    libxv-dev \
    sqlite-dev \
    fribidi-dev \
    libvdpau-dev \
    x264-dev \
    x265-dev \
    xvidcore-dev \
    libvpx-dev \
    libvorbis-dev \
    libogg-dev \
    faac-dev \
    faad2-dev \
    glu-dev \
    libass-dev \
    alsa-lib-dev \
    lame-dev \
    opus-dev \
    fdk-aac-dev \
    libva-dev \
    ffmpeg4-dev \
    pulseaudio-dev \

#
# Download sources.
#

log "Downloading Avidemux sources..."
mkdir /tmp/avidemux
curl -# -L -f ${AVIDEMUX_URL} | tar xz --strip 1 -C /tmp/avidemux

log "Downloading opencore-amr sources..."
mkdir /tmp/opencore-amr
curl -# -L -f ${OPENCORE_AMR_URL} | tar xz --strip 1 -C /tmp/opencore-amr

log "Downloading TwoLame sources..."
mkdir /tmp/twolame
curl -# -L -f ${TWOLAME_URL} | tar xz --strip 1 -C /tmp/twolame

log "Downloading After sources..."
mkdir /tmp/aften
curl -# -L -f ${AFTEN_URL} | tar xj --strip 1 -C /tmp/aften

log "Downloading libdca sources..."
mkdir /tmp/libdca
curl -# -L -f ${LIBDCA_URL} | tar xj --strip 1 -C /tmp/libdca

log "Downloading dcaenc sources..."
mkdir /tmp/dcaenc
curl -# -L -f ${DCAENC_URL} | tar xz --strip 1 -C /tmp/dcaenc

#
# Compile Avidemux.
#

log "Configuring opencore-amr..."
(
    cd /tmp/opencore-amr && ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
)

log "Compiling opencore-amr..."
make -C /tmp/opencore-amr -j$(nproc)

log "Installing opencore-amr..."
make DESTDIR=$(xx-info sysroot) -C /tmp/opencore-amr install

log "Configuring TwoLame..."
(
    cd /tmp/twolame && ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
        --datarootdir=/tmp/twolame-share \
)

log "Compiling TwoLame..."
make -C /tmp/twolame -j$(nproc)

log "Installing TwoLame..."
make DESTDIR=$(xx-info sysroot) -C /tmp/twolame install

log "Patching Aften..."
patch -p1 -d /tmp/aften  < "$SCRIPT_DIR"/aften-fix.patch

log "Configuring Aften..."
(
    mkdir /tmp/aften/build && \
    cd /tmp/aften/build && cmake \
        $(xx-clang --print-cmake-defines) \
        -DCMAKE_FIND_ROOT_PATH=$(xx-info sysroot) \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        ..
)

log "Compiling Aften..."
make -C /tmp/aften/build -j$(nproc)

log "Installing Aften..."
make DESTDIR=$(xx-info sysroot) -C /tmp/aften/build install

log "Configuring libdca..."
(
    cd /tmp/libdca && \
    ./bootstrap && \
    ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
        --datarootdir=/tmp/libdca-share \
)

log "Compiling libdca..."
make -C /tmp/libdca -j$(nproc)

log "Installing libdca..."
make DESTDIR=$(xx-info sysroot) -C /tmp/libdca install

log "Compiling dcaenc..."
(
    cd /tmp/dcaenc && \
    autoreconf -f -i -v && \
    ./configure \
        --build=$(TARGETPLATFORM= xx-clang --print-target-triple) \
        --host=$(xx-clang --print-target-triple) \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
        --disable-alsa \
)

log "Compiling dcaenc..."
make -C /tmp/dcaenc -j$(nproc)

log "Installing dcaenc..."
make DESTDIR=$(xx-info sysroot) -C /tmp/dcaenc install

log "Patching Avidemux..."
patch -p1 -d /tmp/avidemux < "$SCRIPT_DIR"/build-log.patch
patch -p1 -d /tmp/avidemux < "$SCRIPT_DIR"/compilation-fix.patch
patch -p1 -d /tmp/avidemux < "$SCRIPT_DIR"/crashdump.patch
patch -p1 -d /tmp/avidemux < "$SCRIPT_DIR"/memcpy.patch

log "Compiling Avidemux..."
(
    cd /tmp/avidemux && \
    chmod +x bootStrap.bash && \
    ./bootStrap.bash
)

log "Installing Avidemux..."
mkdir /tmp/avidemux-install
cp -Rv /tmp/avidemux/install/usr /tmp/avidemux-install/
