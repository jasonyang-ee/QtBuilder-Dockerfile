

# Docker Container to Build Qt From Source

`build.sh` will invoke a docker container to build Qt from source. The output is compiled Qt library as tarball.

`dev.sh` will create a docker image containing Qt library that can be used to build Qt applications.

Both scripts will build for both linux amd64 and arm64 architecture.



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
        -h, --help                  Show this help message and exit

        -v, --version               List all available versions when no version specified

        -v, --version <VERSION>     Specify the version of Qt to build

        -r, --registry <REGISTRY>   Set the registry as prefix for image name

        -b, --build                 Build the Qt Builder image

        -p, --push                  Push the Qt Builder image to the registry
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
		-h, --help                  Show this help message and exit

		-v, --version <VERSION>     Specify the version of Qt to build

		-r, --registry <REGISTRY>   Set the registry as prefix for image name

		-b, --build                 Build the Qt Development image

		-p, --push                  Push the Qt Development image to the registry
	```

	> Example of making and pushing Qt 6.6.3 development image to the registry
	```bash
	./dev.sh -v 6.6.3 -b -r jasonyangee -p
	```



## Folders Created on the Build

| Folder | Description |
| ------ | ----------- |
| `build` | Contains compiled Qt library. |
| `src` | Contains downloaded Qt source code. |
| `cache` | Contains docker builderx cache. |



## Cautions

Building Qt is resource intensive. It is recommended to have at least **32GB of RAM** and **20 logical CPU cores**.
