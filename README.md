

# Docker Container for Qt Building Environment

BuilderQt is a Docker container for building Qt source code for both amd64 and arm64. It require docker buildx setup with using docker-container driver. It will produce a compliled Qt binary and library tar file.




## Usage

- Build Qt using `BuilderQt.sh` script.
  
	It will produce a output to the `build` folder.

	> Example Command
	```bash
	./Build-QtBuilder.sh -h
	./Build-QtBuilder.sh -v 6.6.1
	```

## Cautions

Building Qt is resource intensive. It is recommended to have at least 8GB of RAM and 4 CPU cores for building Qt. Otherwise, the build process may fail.
