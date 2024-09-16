# zephyr

- zephyr version: v3.7.0

## Pre-requisite

- Ultra96 v2 platform muat be build in advance by following [README.md](../platform/README.md)

## Set up environment

- Set up Zephyr environment according to [Getting Started Guide](https://docs.nordicsemi.com/bundle/ncs-latest/page/zephyr/develop/getting_started/index.html)

```shell-session
$ sudo apt install python-is-python3 python3-venv device-tree-compiler ninja-build gperf
$ wget https://apt.kitware.com/kitware-archive.sh

$ python3 -m venv ./zephyrproject/.venv
$ source ./zephyrproject/.venv/bin/activate
$ pip install pyelftools
$ pip cache purge

$ west init ./zephyrproject
$ cd ./zephyrproject
$ west update
```

## Build

```shell-session
# copy Ultra96 V2 board files
$ cp -R src/ultra96v2/ zephyrproject/zephyr/boards/amd

# create application .elf
$ pushd zephyrproject
$ west build -p always -b ultra96v2 samples/hello_world
$ popd

# generate BOOT.bin
$ make -f src/makefile
```

## Run

- Copy ``sd_card/BOOT.BIN`` into micro SD card & boot up the board

```shell-session
Zynq MP First Stage Boot Loader 
Release 2024.1   Sep 16 2024  -  10:24:25
PMU-FW is not running, certain applications may not be supported.
*** Booting Zephyr OS build v3.7.0-2791-g50b07f9480a4 ***
Hello World! ultra96v2/zynqmp_rpu
```

***

## References

- [Zephyr RTOS and Cortex-R5 on Zynq UltraScale+](https://antmicro.com/blog/2019/09/zephyr-cortex-r5-on-ultrascale/)
