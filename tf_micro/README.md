# TensorFlow for micro controllers on RPU

***

## Generate FSBL & BSP

- Generate HW

```shell-session
$ vivado -mode batch -source create_vivado_project.tcl
```

- Create BSP (for FSBL & App)

```shell-session
xsct% source create_boot_bin.tcl
```

***

## Get TensorFlow source

```shell-session
$ git clone https://github.com/tensorflow/tensorflow.git
```

