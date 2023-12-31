#!/bin/bash

version=6.6.1

# Build Qt Builder Image
docker build -t qt-builder:6 -f ./QtBuilder/Dockerfile.builder ./QtBuilder

# Use above Qt Builder Image to build Qt
# Native AMD64 Build
docker run \
	-v $PWD/build:/root/export \
	qt-builder:6 /build_qt6_amd64.sh $version
# Cross ARM64 Build
docker run \
	-v $PWD/build:/root/export \
	qt-builder:6 /build_qt6_arm64.sh $version