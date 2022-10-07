# TensorFlow for micro (MNIST digit classification) controllers on RPU

- Make sure to build platform by following this [README.md](../platform/README.md)

- TensorFlow Version: v2.4.1

***

## Create application

### Build TensorFlow micro static library

```shell-session
# set up toolchain
$ . <Vitis install directory>/Vitis/2022.1/settings64.sh

# clone TFLite Micro repo
$ git clone https://github.com/tensorflow/tflite-micro.git
$ cd tflite-micro

# start build
$ make -j$(nproc) -f ./tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- COMMON_FLAGS="-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16"
$ cd ..
```

- Output static library can be found as ``tflite-micro/gen/linux_armv7r_default/lib/libtensorflow-microlite.a``

## Build testing app (generate BOOT.BIN)

```shell-session
# Set environment variable to find the generated platform
$ export PLATFORM_REPO_PATHS=$(dirname $(pwd))/platform/_pfm/u96v2_r5/export/u96v2_r5
$ xsct create_testing.tcl
```

- BOOT.BIN will be generated in ``_vitis_tflm_testing/tflm_testing_system/Release/sd_card``

## Run

- Copy the generated BOOB.BIN into a micro SD card & boot up the board

- Result:

```shell-session
Xilinx Zynq MP First Stage Boot Loader 
Release 2022.1   Sep 25 2022  -  12:50:24
PMU-FW is not running, certain applications may not be supported.
Testing ArgumentsExecutedOnlyOnce
Testing TestExpectEQ
Testing TestExpectNE
3/3 tests passed
~~~ALL TESTS PASSED~~~
```
