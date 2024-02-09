FROM debian:bookworm as qt-environment

ARG TARGETARCH

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	git \
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
	libclang-dev \
	libgl1-mesa-dev \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

FROM qt-environment as building

COPY qt-everywhere-src-6.6.1.tar.xz /source/qt-everywhere-src-6.6.1.tar.xz
RUN mkdir -p /Qt6/Src /Qt6/Build
RUN tar xvfp /source/qt-everywhere-src-6.6.1.tar.xz -C /Qt6/Src --strip-components=1

RUN cd /Qt6/Build \
	&& /Qt6/Src/configure -prefix /opt/Qt6 -release -nomake examples -nomake tests \
	&& cmake --build . --parallel $(nproc) \
	&& cmake --install .

RUN tar cvfpJ /export/Qt6-$TARGETARCH.tar.xz -C /opt/Qt6 .

FROM scratch as artifact
COPY --from=building /export/Qt6-$TARGETARCH.tar.xz /Qt6-$TARGETARCH.tar.xz