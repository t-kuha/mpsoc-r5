# TensorFlow for micro (MNIST digit classification) controllers on RPU

- Make sure to build platform by following this [README.md](../platform/README.md)

- TensorFlow Version: v2.4.1

***

## Create application

### Build TensorFlow micro static library

```shell-session
# set up toolchain
$ . <Vitis install directory>/Vitis/2024.1/settings64.sh

# clone TFLite Micro repo
$ git clone https://github.com/tensorflow/tflite-micro.git
$ pushd tflite-micro

# start build
$ make -j$(nproc) -f ./tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- COMMON_FLAGS="-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16 -std=c++14"
$ popd
```

- Output static library can be found as ``tflite-micro/gen/linux_armv7r_default_gcc/lib/libtensorflow-microlite.a``

## Build testing app (generate BOOT.BIN)

```shell-session
$ vitis -s create_testing_app.py
$ bootgen -image ./create_testing_app.bif -arch zynqmp -o BOOT.bin -w on
```

## Run

- Copy the generated BOOB.bin into a micro SD card & boot up the board

- Result:

```shell-session
Zynq MP First Stage Boot Loader 
Release 2024.1   Jun  1 2024  -  05:52:39
PMU-FW is not running, certain applications may not be supported.
Testing ArgumentsExecutedOnlyOnce
Testing TestExpectEQ
Testing TestExpectNE
3/3 tests passed
~~~ALL TESTS PASSED~~~
```
