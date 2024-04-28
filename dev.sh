#!/bin/bash

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
			echo "No version specified" >&2
			exit 1
		else
			VERSION="$2"
			shift # past argument
			shift # past value
		fi
		echo "Using $VOLUME as volume mount point"
		;;
	-r | --registry)
		# Check if has argument value
		if [[ -z "$2" ]]; then
			echo "No registry specified" >&2
			exit 1
		else
			REGISTRY="$2"
			shift # past argument
			shift # past value
		fi
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
	echo "  -h, --help                Show this help message and exit"
	echo ""
	echo "  -v, --version <VERSION>   Set the version of Qt to use for dev environment"
	echo ""
	echo "  -r, --registry <REGISTRY>  Set the registry as prefix for image name"
	exit 0
fi

if [ ! -d "build-$VERSION" ]; then
	echo "Qt Version $VERSION not found" >&2
	exit 1
fi

if [ -z "$VERSION" ]; then
	echo "No version specified" >&2
	exit 1
fi

if [ -z "$REGISTRY" ]; then
	echo "No registry specified" >&2
	exit 1
fi

# Build Qt Developer Image using the compiled Qt
docker buildx build \
	--load \
	--platform linux/amd64,linux/arm64 \
	--build-arg VERSION=$VERSION \
	-t $REGISTRY/qt-dev:$VERSION \
	-f Dockerfile.dev .
