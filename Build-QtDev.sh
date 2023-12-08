#!/bin/bash

version=6.6.0

# Build Qt Developer Image
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--build-arg QTVER=$version \
	-t qt-dev:$version \
	-f ./QtDev/Dockerfile.dev \
	./QtDev
