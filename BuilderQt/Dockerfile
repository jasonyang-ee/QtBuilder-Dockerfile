FROM debian:bookworm as qt-environment

ARG TARGETARCH
ARG VERSION

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	git \
	curl \
	xz-utils \
	cmake \
	ninja-build \
	build-essential \
	ca-certificates \
	python3 \
	python3-pip \
	libfontconfig1-dev \
	libfreetype6-dev \
	libx11-dev \
	libx11-xcb-dev \
	libxext-dev \
	libxfixes-dev \
	libxi-dev \
	libxrender-dev \
	libxcb1-dev \
	libxcb-cursor-dev \
	libxcb-glx0-dev \
	libxcb-keysyms1-dev \
	libxcb-image0-dev \
	libxcb-shm0-dev \
	libxcb-icccm4-dev \
	libxcb-sync-dev \
	libxcb-xfixes0-dev \
	libxcb-shape0-dev \
	libxcb-randr0-dev \
	libxcb-render-util0-dev \
	libxcb-util-dev \
	libxcb-xinerama0-dev \
	libxcb-xkb-dev \
	libxkbcommon-dev \
	libxkbcommon-x11-dev \
	libgl1-mesa-dev \
	libfontconfig1 \
	libxkbcommon0 \
	libgl1 \
	libpng16-16 \
	libfreetype6 \
	libwayland-* \
	libwayland-dev \
	libvulkan1 \
	mesa-vulkan-drivers \
	libnvidia-egl-wayland-dev \
	python3-html5lib \
	libclang-dev \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

ENV LLVM_INSTALL_DIR="/usr/llvm"




FROM qt-environment as download

RUN mkdir -p /Qt6/Src /Qt6/Build /Qt6/Build-arm64 /export /source
COPY src/qt-everywhere-src-$VERSION.tar.xz /source/qt.tar.xz

RUN tar xvfp /source/qt.tar.xz -C /Qt6/Src --strip-components=1
RUN rm -rf /source



FROM download as building

WORKDIR /Qt6/Build
RUN /Qt6/Src/configure -prefix /opt/Qt6 -release -nomake examples -nomake tests
RUN cmake --build . --parallel $(nproc)
RUN cmake --install .

RUN tar cvfpJ /export/Qt6-$TARGETARCH.tar.xz -C /opt/Qt6 .



FROM scratch as artifact
COPY --from=building /export /