# TensorFlow for micro (MNIST digit classification) controllers on RPU

- Make sure to build platform by following this [README.md](../platform/README.md)

- TensorFlow Version: v2.4.1

***

## Create application

### Build TensorFlow micro static library

```sh
$ wget https://github.com/tensorflow/tensorflow/archive/v2.4.1.tar.gz
$ tar xf v2.4.1.tar.gz

$ cd tensorflow-2.4.1/
$ make -j$(nproc) -f tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- TAG_DEFINES="-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16" microlite
```

- Output static library can be found as ``tensorflow/lite/micro/tools/make/gen/linux_armv7r/lib/libtensorflow-microlite.a``

## Build SW (generate BOOT.BIN)

```shell-session
# Set environment variable to find the generated platform
$ export PLATFORM_REPO_PATHS=$(dirname $(pwd))/platform/_pfm/u96v2_r5/export/u96v2_r5
$ xsct create_app.tcl
```

- BOOT.BIN will be generated in ``_vitis/tf_micro_system/Release/sd_card``

## Run

- Copy the generated BOOB.BIN into a micro SD card & boot up the board

- Result:

```shell-session
Xilinx Zynq MP First Stage Boot Loader 
Release 2020.2   Jan 23 2021  -  08:48:22
PMU-FW is not running, certain applications may not be supported.
..... TensorFlow Lite for Micro Controllers ...
TF version: 2.4.1
[INFO] Input size: 1 x 28 x 28 x 1
[INFO] Quantization param:
    type:       1
    scale:      0.00392157
    zero point: -128
Score[0]: -128
Score[1]: -128
Score[2]: -128
Score[3]: -128
Score[4]: -128
Score[5]: -128
Score[6]: -128
Score[7]: 127
Score[8]: -128
Score[9]: -128
Output: 7
..... DONE .....
```

***

## Generating model

- Run [jupyter-notebook/mnist_for_tf_micro.ipynb](jupyter-notebook/mnist_for_tf_micro.ipynb)
  - After running this notebook, ``model_quant.cc`` will be generated
