#!/bin/bash

version=6.6.0

docker build -t qt-builder:6 -f ./QtBuilder/Dockerfile.builder ./QtBuilder

# Native AMD64 Build
docker run -it --name qt-builder-amd \
	-v $PWD/qt_export:/root/export \
    -v $(pwd)/QtBuilder/build_qt6_amd64.sh:/build_qt6_amd64.sh \
	qt-builder:6 /build_qt6_amd64.sh $version

# Cross ARM64 Build
docker run -it --name qt-builder-arm \
	-v $PWD/qt_export:/root/export qt-builder:6 \
	-v $(pwd)/QtBuilder/build_qt6_arm64.sh:/build_qt6_arm64.sh \
	qt-builder:6 /build_qt6_arm64.sh $version