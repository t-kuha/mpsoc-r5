# Createing Vitis Platform for RPU

## Create HW

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## Generate Platform

```shell-session
$ vitis -s create_platform.py
```

- Platform files will be in ``_pfm/u96v2_r5/export/u96v2_r5/``
