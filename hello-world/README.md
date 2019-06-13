# Hello World

- For Ultra96 (v1) board

***

## Create HW

```shell-session
$ vivado -mode batch -source create_vivado_project.tcl
```

***

## Build SW (BOOT.BIN)

- SD card image

```shell-session
xsct% source create_boot_bin.tcl
```

***

## Run

- Copy BOOT.bin into micro SD card & boot the board

***

## Reference

- UG1209 Zynq UltraScale+ MPSoC: Embedded Design Tutorial A Hands-On Guide to Effective Embedded System Design
