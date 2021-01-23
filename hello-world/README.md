# Hello World

- Make sure to build platform by following this [README.md](../platform/README.md)

***

## Build SW (generate BOOT.BIN)

```shell-session
# Set environment variable to find the generated platform
$ export PLATFORM_REPO_PATHS=$(dirname $(pwd))/platform/_pfm/u96v2_r5/export/u96v2_r5
$ xsct create_app.tcl
```

## Run

- Copy ``_vitis/hello_world_system/Release/sd_card/BOOT.BIN`` into micro SD card & boot the board

```shell-session
Xilinx Zynq MP First Stage Boot Loader 
Release 2020.2   Jan 23 2021  -  08:48:22
PMU-FW is not running, certain applications may not be supported.
Hello World
```
