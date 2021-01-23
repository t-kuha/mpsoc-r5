# Createing Vitis Platform for RPU

## Create HW

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Generate Platform

```shell-session
$ xsct create_platform.tcl
```

- Platform files will be in ``_pfm/u96v2_r5/export/u96v2_r5/``
