

# Docker Container for Qt Building Environment

QtBuilder is a Docker container for building Qt framework environment. It will produce a complete Qt environment with all the necessary tools and libraries for building Qt applications.

QtDev is a base Docker container for developing Qt applications.

User must take QtDev as a base image and add their own Qt application source code into the container to compile the application.

## Usage

1. Build Qt using `Build-QtBuilder.sh` script
	1. It will produce a Docker image named `qt-builder` .
	2. It will produce compiled Qt libraries (amd64 & arm64) in the `build` folder.
2. Build Qt development environment using `Build-QtDev.sh` script
	1. It will produce a Docker image named `qt-dev`.


In those two scripts, you can change the Qt version by changing the `version` variable in the script. Currently, only major version 6 has been tested.


## Cautions

Building Qt is resource intensive. It is recommended to have at least 8GB of RAM and 4 CPU cores for building Qt. Otherwise, the build process may fail.
