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
		if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
			echo "No version specified" >&2
			exit 1
		else
			VERSION="$2"
			shift # past argument
			shift # past value
		fi
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
	-b | --build)
		BUILD=true
		shift # past argument
		;;
	-s | --slim)
		SLIM=true
		shift # past argument
		;;
	-p | --push)
		PUSH=true
		shift # past argument
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
	echo "  -v, --version <VERSION>    Set the version of Qt to use for dev environment"
	echo ""
	echo "  -r, --registry <REGISTRY>  Set the registry as prefix for image name"
	echo ""
	echo "  -b, --build                Build the Qt Developer image"
	echo ""
	echo "  -s, --slim                Build slim version of the Qt Developer image"
	echo ""
	echo "  -p, --push                 Push the Qt Developer image to Docker Hub"
	echo ""
	echo "  -t, --target <TARGET>      Override the target platform for the image"
	echo "                             Format follows the docker buildx platform format"
	echo "                             [Default: linux/amd64,linux/arm64]"
	exit 0
fi

# Check if the tarball of the specified Qt version has been produced by the build.sh script
if [[ ! -d "build-$VERSION" ]]; then
	echo "Tarball of the specified Qt version $VERSION not found" >&2
	exit 1
fi

# Check if the version is specified
if [[ -z "$VERSION" ]]; then
	echo "No version specified" >&2
	exit 1
fi

# Check if the registry is specified when the push flag is set
if [[ $PUSH == true && -z "$REGISTRY" ]]; then
	echo "No registry specified" >&2
	exit 1
fi

# Check if the tarball of the specified architecture has been produced by the build.sh script
TARGETS=${TARGET//,/ }
ARCHS=""
for ITEM in $TARGETS; do
	ARCHS+="$(echo $ITEM | cut -d'/' -f2)"
	ARCHS+=" "
done
for ARCH in $ARCHS; do
	if [[ ! -f "build-$VERSION/Qt6-$ARCH.tar.xz" ]]; then
		echo "Tarball of the specified Qt version $VERSION for $ARCH not found" >&2
		exit 1
	fi
done

# Build Qt Developer Image using the compiled Qt
if [[ $BUILD == true ]]; then
	docker buildx build \
		--load \
		--platform $TARGET \
		--build-arg VERSION=$VERSION \
		-t ${REGISTRY}qt-dev:$VERSION \
		-f Dockerfile.dev .
fi

# Build Qt Developer Image using the compiled Qt
if [[ $SLIM == true ]]; then
	docker buildx build \
		--load \
		--platform $TARGET \
		--build-arg VERSION=$VERSION \
		-t ${REGISTRY}qt-dev:$VERSION-slim \
		-f Dockerfile.dev-slim .
fi

# Push the Qt Developer Image to Docker Hub
if [[ $PUSH == true ]]; then
	docker push ${REGISTRY}qt-dev:$VERSION
fi

# Pushover Notification
if [ -x "$(command -v ntfy)" ]; then ntfy send "build qt-builder complete"; fi
