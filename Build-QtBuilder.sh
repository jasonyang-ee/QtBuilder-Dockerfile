#!/bin/bash

# Build Qt Builder Image
docker buildx build --target=artifact --output type=local,dest=$(pwd)/build/ --platform linux/amd64,linux/arm64 -t qt-builder:latest -f ./QtBuilder/Dockerfile.builder ./QtBuilder

if [ -x "$(command -v ntfy)" ]; then ntfy send "build qt-builder complete"; fi