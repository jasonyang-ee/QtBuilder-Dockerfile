FROM debian:bookworm-slim as QtEnvironment

ARG TARGETPLATFORM
ARG QTVER

COPY ../build/Qt-amd64-$QTVER.tar.xz /root/
COPY ../build/Qt-arm64-$QTVER.tar.xz /root/
COPY ../QtBuilder/toolchain.cmake /root/

RUN cd /opt && \
    if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
		tar xvfp /root/Qt-arm64-$QTVER.tar.xz && \
		rm /root/Qt-arm64-$QTVER.tar.xz \
	fi

RUN cd /opt && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        tar xvfp /root/Qt-amd64-$QTVER.tar.xz; \
        rm /root/Qt-amd64-$QTVER.tar.xz; \
        cd /opt/qt/$QTVER; \
        mv /opt/Qt-amd64-$QTVER gcc_64; \
        ln -s $PWD/gcc_64 /opt/Qt-amd64-$QTVER; \
    fi

RUN echo "/opt/Qt-$TARGETPLATFORM-$QTVER/lib" >> /etc/ld.so.conf && ldconfig

RUN rm -f /root/Qt-amd64-$QTVER.tar.xz \
	&& rm -f /root/Qt-arm64-$QTVER.tar.xz

RUN apt-get -y autoremove \
	&& apt-get -y autoclean \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/opt/Qt-$TARGETPLATFORM-$QTVER"
ENV QT_DIR="/opt/Qt-$TARGETPLATFORM-$QTVER/"



FROM QtEnvironment as DevEnvironment

# Regular build tools
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    apt-utils curl nano git cmake build-essential ninja-build \
	libwayland-client0 libwayland-server0 libglx-mesa0 mesa-utils-extra libegl1 libgles2 libgles-dev \
	libxcb-cursor0 \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*