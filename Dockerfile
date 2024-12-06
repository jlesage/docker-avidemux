#
# avidemux Dockerfile
#
# https://github.com/jlesage/docker-avidemux
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG AVIDEMUX_VERSION=2.8.1
ARG OPENCORE_AMR_VERSION=0.1.5
ARG TWOLAME_VERSION=0.4.0
ARG AFTEN_VERSION=0.0.8
ARG LIBDCA_VERSION=0.0.7
ARG DCAENC_VERSION=3

# Define software download URLs.
ARG AVIDEMUX_URL=https://downloads.sourceforge.net/project/avidemux/avidemux/${AVIDEMUX_VERSION}/avidemux_${AVIDEMUX_VERSION}.tar.gz
ARG OPENCORE_AMR_URL=https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCORE_AMR_VERSION}.tar.gz
ARG TWOLAME_URL=https://downloads.sourceforge.net/project/twolame/twolame/${TWOLAME_VERSION}/twolame-${TWOLAME_VERSION}.tar.gz
ARG AFTEN_URL=https://downloads.sourceforge.net/project/aften/aften/${AFTEN_VERSION}/aften-${AFTEN_VERSION}.tar.bz2
ARG LIBDCA_URL=https://download.videolan.org/pub/videolan/libdca/${LIBDCA_VERSION}/libdca-${LIBDCA_VERSION}.tar.bz2
ARG DCAENC_URL=https://gitlab.com/patrakov/dcaenc/-/archive/v${DCAENC_VERSION}/dcaenc-v${DCAENC_VERSION}.tar.gz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build Avidemux.
FROM --platform=$BUILDPLATFORM alpine:3.16 AS avidemux
ARG TARGETPLATFORM
ARG AVIDEMUX_URL
ARG OPENCORE_AMR_URL
ARG TWOLAME_URL
ARG AFTEN_URL
ARG LIBDCA_URL
ARG DCAENC_URL
COPY --from=xx / /
COPY src/avidemux /build
RUN /build/build.sh \
    "$AVIDEMUX_URL" \
    "$OPENCORE_AMR_URL" \
    "$TWOLAME_URL" \
    "$AFTEN_URL" \
    "$LIBDCA_URL" \
    "$DCAENC_URL" \
RUN xx-verify \
    /tmp/avidemux-install/usr/bin/avidemux3_qt5 \
    /usr/bin/avidemux3_jobs_qt5 \
    /usr/bin/avidemux3_cli

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.6.7

ARG AVIDEMUX_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        sqlite-libs \
        qt5-qtbase-x11 \
        glu \
        libva \
        libvdpau \
        libxv \
        libvorbis \
        lame \
        faac \
        alsa-lib \
        faad2-libs \
        opus \
        x264-libs \
        x265 \
        xvidcore \
        fribidi \
        fdk-aac \
        libvpx \
        font-croscore \
        libpulse

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/avidemux-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=avidemux /tmp/avidemux-install/usr/bin /usr/bin
COPY --from=avidemux /tmp/avidemux/install/usr/lib /usr/lib
COPY --from=avidemux /tmp/avidemux-install/usr/share/avidemux6 /usr/share/avidemux6

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Avidemux" && \
    set-cont-env APP_VERSION "$AVIDEMUX_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="avidemux" \
      org.label-schema.description="Docker container for Avidemux" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-avidemux" \
      org.label-schema.schema-version="1.0"
