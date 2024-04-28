

# Docker Container to Build Qt From Source

`build.sh` will invoke a docker container to build Qt from source. The output of `build.sh` is compiled Qt library as tarball.

`dev.sh` will create a docker image that contains Qt library and development tools. It can be used to build Qt applications.



## Requirement

It require docker buildx setup with using docker-container driver.

[Official Guide on Docker Buildx](https://docs.docker.com/reference/cli/docker/buildx/create/#driver)

![Docker Buildx](docs/img/builder.png)




## To Use `build.sh`

- Build Qt using `build.sh` script.
  
	It will produce an output to the `build-$version` folder.

	> Help Command
	```bash
	./build.sh --help
	```
	```bash
	Usage: build.sh [OPTIONS]
	Options:
        -h, --help                Show this help message and exit

        -v, --version             No version specified, list all available versions

        -v, --version <VERSION>   Specify the version of Qt to build

        -b, --build               Build the Qt Builder image

        -p, --push                Push the Qt Builder image to the registry
	```

	> Example of building Qt 6.6.3
	```bash
	./build.sh -v 6.6.3 -b
	```


## To Use `dev.sh`

- Build Qt development image using `dev.sh` script.

	> Help Command
	```bash
	./dev.sh --help
	```
	```bash
	Usage: dev.sh [OPTIONS]
	Options:
		-h, --help                Show this help message and exit

		-v, --version <VERSION>   Specify the version of Qt to build

		-b, --build               Build the Qt Development image

		-p, --push                Push the Qt Development image to the registry
	```

	> Example of making and pushing Qt 6.6.3 development image to the registry
	```bash
	./dev.sh -v 6.6.3 -b -p
	```



## Folders Created on the Build

| Folder | Description |
| ------ | ----------- |
| `build` | Contains compiled Qt library. |
| `src` | Contains downloaded Qt source code. |
| `cache` | Contains docker builderx cache. |



## Cautions

Building Qt is resource intensive. It is recommended to have at least **32GB of RAM** and **20 logical CPU cores** for building Qt.
