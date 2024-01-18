#!/bin/bash


# Build Qt Builder Image
docker buildx build --platform linux/amd64 -t qt-builder:6 -f ./QtBuilder/Dockerfile.builder ./QtBuilder
