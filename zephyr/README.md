# zephyr

## Set up environment

- Set up Zephyr environment according to [Getting Started Guide](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/zephyr/develop/getting_started/index.html)

## Build

- Copy Ultra96 V2 board files

```shell-session
$ cp -R src/ultra96v2/ zephyrproject/zephyr/boards/arm
```

- Create application .elf

```shell-session
$ pushd $(pwd)
$ west build -p auto -b ultra96v2 samples/hello_world/
$ popd
```

- Generate BOOT.bin

```shell-session
$ make -f src/makefile
```

## Run

- Copy ``sd_card/BOOT.BIN`` into micro SD card & boot up the board

```shell-session
Xilinx Zynq MP First Stage Boot Loader 
Release 2022.1   Sep 25 2022  -  12:50:24
PMU-FW is not running, certain applications may not be supported.
*** Booting Zephyr OS build zephyr-v3.2.0-1-gfd2a0d4f9c54  ***
Hello World! ultra96v2
```

***

## References

- [Zephyr RTOS and Cortex-R5 on Zynq UltraScale+](https://antmicro.com/blog/2019/09/zephyr-cortex-r5-on-ultrascale/)
