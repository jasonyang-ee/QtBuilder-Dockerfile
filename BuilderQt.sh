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
		# Default values
		VERSION=6.6.1
		# Check if has argument value
		if [[ -z "$2" ]]; then
			shift # past argument
		else
			VERSION="$2"
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
	echo "Usage: BuilderQt.sh [OPTIONS]"
	echo "Options:"
	echo "  -h, --help                Show this help message and exit"
	echo ""
	echo "  -v, --version <VERSION>   Overwrite the version of Qt to build"
	echo "                            [Avalible: 6.6.1, 6.5.3, 6.2.7]"
	echo "                            [Default:  6.6.1]"
	echo ""
	exit 0
fi


# Avaliable Versions


# Build Qt Builder Image
if [[ "$VERSION" = "6.6.1" ]] || [[ "$VERSION" = "6.5.3" ]] || [[ "$VERSION" = "6.2.7" ]]; then
	echo "Compiling Qt Version $VERSION"
	docker buildx build --target=artifact --output type=local,dest=$(pwd)/build/ --platform linux/amd64,linux/arm64 -t qt-builder:latest --build-arg VERSION=${VERSION} --load ./BuilderQt
else
	echo "Invalid Version"
fi

if [ -x "$(command -v ntfy)" ]; then ntfy send "build qt-builder complete"; fi