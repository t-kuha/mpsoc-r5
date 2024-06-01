# Hello World

- Make sure to build platform by following this [README.md](../platform/README.md)

***

## Build SW (generate BOOT.BIN)

```shell-session
$ vitis -s create_platform.py
$ bootgen -image ./hello-world.bif -arch zynqmp -o BOOT.bin -w on
```

## Run

- Copy ``BOOT.BIN`` into micro SD card & boot the board

```shell-session
Release 2024.1   Jun  1 2024  -  02:45:09
PMU-FW is not running, certain applications may not be supported.
Hello World
Successfully ran Hello World application
```
