#!/bin/bash

version=6.6.0

# Build Qt Developer Image
docker buildx build --platform linux/amd64,linux/arm64 --build-arg TARGETARCH=arm64 QTVER=6.6.0 -t qt-dev:6 -f ./QtDev/Dockerfile.dev ./QtDev
