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
	libclang-dev \
	libgl1-mesa-dev \
	&& apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*



FROM qt-environment as download

RUN mkdir -p /Qt6/Src /Qt6/Build /export /source

RUN \
	if [ "$VERSION" = "6.6.1" ]; then curl -L -o /source/qt.tar.xz https://download.qt.io/official_releases/qt/6.6/6.6.1/single/qt-everywhere-src-6.6.1.tar.xz; \
	elif [ "$VERSION" = "6.5.3" ]; then curl -L -o /source/qt.tar.xz https://download.qt.io/official_releases/qt/6.5/6.5.3/single/qt-everywhere-src-6.5.3.tar.xz; \
	fi

RUN tar xvfp /source/qt.tar.xz -C /Qt6/Src --strip-components=1



FROM download as building

WORKDIR /Qt6/Build
RUN /Qt6/Src/configure -prefix /opt/Qt6 -release -nomake examples -nomake tests
RUN cmake --build . --parallel $(nproc)
RUN cmake --install .

RUN tar cvfpJ /export/Qt6-$TARGETARCH.tar.xz -C /opt/Qt6 .



FROM scratch as artifact
COPY --from=building /export /