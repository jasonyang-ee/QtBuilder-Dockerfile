#!/bin/bash

# Default values
VERSION=6.6.1

# Parse arguments
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
	case $1 in
	-h | --help)
		HELP=true
		shift # past argument
		;;
	-v | --version)
		# Check if has argument value
		if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
			shift # past argument
		else
			VERSION="$2"
			shift # past argument
			shift # past value
		fi
		echo "Using $VOLUME as volume mount point"
		;;
	-* | --*=) # unsupported argument
		echo "Unsupported argument '$1'" >&2
		echo "See '--help' for more information"
		exit 1
		;;
	esac
done

# Check for help flag
if [[ $HELP == true ]]; then
	echo "Usage: build.sh [OPTIONS]"
	echo "Options:"
	echo "  -h, --help              Show this help message and exit"
	echo "  -v, --version <VERSION>   Specify the version of Qt to build"
	exit 0
fi

# Disable the POSIX path conversion in Git Bash (MinGW) 
export MSYS_NO_PATHCONV=1

# Native AMD64 Build using the Qt Builder Image
docker run --rm -v ${PWD}/build:/root/export qt-builder:6 /build_qt6_amd64.sh $VERSION

# Cross ARM64 Build using the Qt Builder Image
docker run --rm -v ${PWD}/build:/root/export qt-builder:6 /build_qt6_arm64.sh $VERSION

# Build Qt Developer Image using the compiled Qt
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--build-arg QTVER=$VERSION \
	-t qt-dev:$VERSION \
	-f ./QtDev/Dockerfile.dev \
	./QtDev
