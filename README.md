

# Docker Container for Qt Building Environment

BuilderQt is a Docker container for building Qt source code for both amd64 and arm64. It require docker buildx setup with using docker-container driver. It will produce a compliled Qt binary and library tar file.




## To Use

- Build Qt using `BuilderQt.sh` script.
  
	It will produce an output to the `build` folder.

	> Help Command
	```bash
	./BuilderQt.sh --help
	```
	```bash
	Usage: BuilderQt.sh [OPTIONS]
	Options:
        -h, --help                Show this help message and exit

        -v, --version <VERSION>   Overwrite the version of Qt to build
                                  [Avalible: 6.6.3, 6.5.3]
                                  [Default:  6.6.3]
	```

	> Build Qt 6.6.1
	```bash
	./BuilderQt.sh -v 6.6.1
	```

## Cautions

Building Qt is resource intensive. It is recommended to have at least 32GB of RAM and 20 logical CPU cores for building Qt.
