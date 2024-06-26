

# Docker Container to Build Qt From Source

`build.sh` will invoke a docker container to build Qt from source. The output is compiled Qt library as tarball.

`dev.sh` will create a docker image containing Qt library that can be used to build Qt applications.

The main goal of this project is to build Qt for ARM64 architecture.

Both scripts will build for linux AMD64 and ARM64 architecture by default.



## Requirement

It require docker buildx setup with using docker-container driver.

[Official Guide on Docker Buildx](https://docs.docker.com/reference/cli/docker/buildx/create/#driver)

![Docker Buildx](docs/img/builder.png)




## To Use `build.sh`

- Build Qt from source using `build.sh` script.
  
	It will produce an binary library output to the `build-$version` folder.

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

        -b, --build                 Build Qt from source into a library binary tarball

        -l, --load                  Save Qt compiled image in local docker (--output=type=docker)

        -t, --target <TARGET>       Override the target platform for the image
                                    Format follows the docker buildx platform format
	                                [Default: linux/amd64,linux/arm64]
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

        -t, --target <TARGET>       Override the target platform for the image
                                    Format follows the docker buildx platform format
	                                [Default: linux/amd64,linux/arm64]
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




## Developer of GUI Application

The following example will focus on using RaspberryOS as the target device OS.

To start GUI application in docker container, you need to have the following setup:

1. Allow the docker container to access X server on host machine.
	```bash
	host-machine> xhost +local:
	```
	```bash
	# if running in ssh session
	host-machine> export DISPLAY=:0
	```

2. Run the docker container with forwarding `DISPLAY env` and volume bind `x11 socket`.
	```bash
	docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix <image_name>
	# import your application volume here if not using this as base image to build your application custom image
	```




## ENV QT_QPA_PLATFORM=eglfs

`eglfs` is used as default. Change this in the `Dockerfile.dev` if you want to use another platform.



## Cautions

Building Qt for ARM64 is the true intend of this project.

However, building Qt for ARM64 is resource intensive due to the cross-compilation process.

It is recommended to have at least **24GB of RAM** and **20 logical CPU cores**.


## Alternative

If you don't have the computer resource to do this. Move to use the online-installer from Qt.

https://doc.qt.io/qt-6/get-and-install-qt-cli.html

https://download.qt.io/official_releases/online_installers/


```bash
./qt-unified-linux-arm64-online.run install --accept-licenses --accept-messages --accept-obligations --confirm-command --email {qt-account-email} --pw {qt-account-pass} --root /opt/Qt6 qt.qt6.670.src qt.qt6.670.linux_gcc_arm64 qt.qt6.670.addons.qtmultimedia qt.qt6.670.addons.qtserialport qt.qt6.670.debug_info qt.qt6.670.addons.qtcharts qt.qt6.670.qtwaylandcompositor qt.qt6.670.addons qt.qt6.670.debug_info
```


## Common Error

```E: Failed to fetch http://xxxx  Unable to connect to deb.debian.org:80: [IP: xxxx]```

Your IP has been timed-out by the debian arm package server. Use VPN to change your IP for the day.