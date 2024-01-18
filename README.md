

# Docker Container for Qt Building Environment

QtBuilder is a Docker container for building Qt framework environment. It will produce a complete Qt environment with all the necessary tools and libraries for building Qt applications.

QtDev is a base Docker container for developing Qt applications.

User must take QtDev as a base image and add their own Qt application source code into the container to compile the application.



## Usage

- Build Qt using `Build-QtBuilder.sh` script.
  
	It will produce a Docker image named `qt-builder`

	```bash
	./Build-QtBuilder.sh
	```

- Build Qt development environment using `Build-QtDev.sh` script

	It will use `qt-builder` produce compiled Qt libraries (amd64 & arm64) in the `build` folder

	Then it will produce a Docker image named `qt-dev`

	```bash
	./Build-QtDev.sh
	./Build-QtDev.sh --help
	./Build-QtDev.sh --version 6.2.0
	```
	> Only major version 6 has been tested.


## Cautions

Building Qt is resource intensive. It is recommended to have at least 8GB of RAM and 4 CPU cores for building Qt. Otherwise, the build process may fail.
