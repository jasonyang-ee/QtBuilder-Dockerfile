#!/bin/bash

version=6.6.0

docker build -t qt-builder:6 -f ./QtBuilder/Dockerfile.builder ./QtBuilder

Native AMD64 Build
docker run -it --rm --name qt-builder-amd \
	-v $PWD/build:/root/export \
	qt-builder:6 /build_qt6_amd64.sh $version

# Cross ARM64 Build
docker run -it --rm --name qt-builder-arm \
	-v $PWD/build:/root/export \
	qt-builder:6 /build_qt6_arm64.sh $version