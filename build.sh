#!/bin/bash

# Set default values
TARGET="linux/amd64,linux/arm64"

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
		if [[ -z "$2" ]]; then
			shift # past argument
		else
			VERSION="$2"
			shift # past argument
			shift # past value
		fi
		;;
	-b | --build)
		BUILD=true
		shift # past argument
		;;
	-s | --slim)
		SLIM=true
		shift # past argument
		;;
	-l | --load)
		LOAD=true
		shift # past argument
		;;
	-r | --registry)
		# Check if has argument value
		if [[ -z "$2" ]]; then
			echo "No registry specified" >&2
			exit 1
		else
			REGISTRY="$2/"
			shift # past argument
			shift # past value
		fi
		;;
	-t | --target)
		# Check if has argument value
		if [[ -z "$2" ]]; then
			echo "No target specified" >&2
			exit 1
		else
			TARGET="$2"
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
	echo "  -h, --help                 Show this help message and exit"
	echo ""
	echo "  -v, --version              List all available versions when no version specified"
	echo ""
	echo "  -v, --version <VERSION>    Set the version of Qt to build"
	echo ""
	echo "  -r, --registry <REGISTRY>  Set the registry as prefix for image name"
	echo ""
	echo "  -b, --build                Build Qt from source into a library binary tarball"
	echo ""
	echo "  -s, --slim                 Build Slim Version of Qt from source into a library binary tarball"
	echo ""
	echo "  -l, --load                 Save the build result into docker image (--output=type=docker)"
	echo "                             Image is huge, so --load is not default, and --push is not provided"
	echo "                             You can push the image to registry manually if there is a need"
	echo ""
	echo "  -t, --target <TARGET>      Override the target platform for the image"
	echo "                             Format follows the docker buildx platform format"
	echo "                             [Default: linux/amd64,linux/arm64]"
	exit 0
fi

# Find avaliable Versions
FULL_VERSIONS=""
MAJOR_VERSIONS=$(curl -s https://download.qt.io/official_releases/qt/ | grep -oE 'href="[[:digit:]]{1,3}.[[:digit:]]{1,3}' | sed 's/href="//')

for ITEMS in $MAJOR_VERSIONS; do
	FULL_VERSIONS+=$(curl -s https://download.qt.io/official_releases/qt/$ITEMS/ | grep -oE 'href="[[:digit:]]{1,3}.[[:digit:]]{1,3}.[[:digit:]]{1,3}' | sed 's/href="//')
	FULL_VERSIONS+=" " # Add a seperation between major versions
done

# If no version is specified, list all available versions
if [[ -z "$VERSION" ]]; then
	echo "Avaliable versions:"
	echo $FULL_VERSIONS
	exit 0
fi

# Check if VERSION is in FULL_VERSIONS
if [[ ! "${FULL_VERSIONS[@]}" =~ "$VERSION" ]]; then
	echo "Unsupported version '$VERSION'" >&2
	echo "See '--help' for more information"
	exit 1
fi

# Check if src folder NOT contains the file with the version
if [ ! -f "src/qt-everywhere-src-$VERSION.tar.xz" ]; then
	echo "Downloading Qt-Everywhere version $VERSION"
	mkdir -p src
	MAJOR_VERSION=$(echo $VERSION | cut -d. -f1,2)
	# Qt 6.5 uses 'qt-everywhere-opensource-src' and includes 'src' in the URL path
	if [[ "$MAJOR_VERSION" == "6.5" ]]; then
		DOWNLOAD_NAME="qt-everywhere-opensource-src-$VERSION.tar.xz"
		DOWNLOAD_URL="https://download.qt.io/official_releases/qt/$MAJOR_VERSION/$VERSION/src/single/$DOWNLOAD_NAME"
	else
		DOWNLOAD_NAME="qt-everywhere-src-$VERSION.tar.xz"
		DOWNLOAD_URL="https://download.qt.io/official_releases/qt/$MAJOR_VERSION/$VERSION/single/$DOWNLOAD_NAME"
	fi
	curl -L "$DOWNLOAD_URL" -o src/qt-everywhere-src-$VERSION.tar.xz
fi

# Build Qt from source into a library binary tarball
if [[ $BUILD == true ]]; then
	mkdir -p build-$VERSION
	docker buildx build \
		--target=artifact --output type=local,dest=$(pwd)/build-$VERSION/ \
		--platform $TARGET \
		--build-arg VERSION=$VERSION \
		--no-cache \
		-f Dockerfile.build .

	# if multi-platform TARGET used, for each subfolder in build-$VERSION, move the compiled file up one folder
	if [[ $TARGET == *","* ]]; then
		for FOLDER in $(ls build-$VERSION); do
			mv build-$VERSION/$FOLDER/* build-$VERSION/
			rm -r build-$VERSION/$FOLDER
		done
	fi
fi

# Build Slim Version of Qt from source into a library binary tarball
if [[ $SLIM == true ]]; then
	mkdir -p build-$VERSION-slim
	docker buildx build \
		--target=artifact --output type=local,dest=$(pwd)/build-$VERSION-slim/ \
		--platform $TARGET \
		--build-arg VERSION=$VERSION \
		--no-cache \
		-f Dockerfile.build-slim .

	# if multi-platform TARGET used, for each subfolder in build-$VERSION, move the compiled file up one folder
	if [[ $TARGET == *","* ]]; then
		for FOLDER in $(ls build-$VERSION-slim); do
			mv build-$VERSION-slim/$FOLDER/* build-$VERSION-slim/
			rm -r build-$VERSION-slim/$FOLDER
		done
	fi
fi

# Save Qt compiled image in local docker
if [[ $LOAD == true ]]; then
	docker buildx build \
		--target=building --load \
		--platform $TARGET \
		-t ${REGISTRY}qt-build:$VERSION \
		--build-arg VERSION=$VERSION \
		-f Dockerfile.build .
fi

# Pushover Notification
if [ -x "$(command -v ntfy)" ]; then ntfy send "build qt-build complete"; fi
