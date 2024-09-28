# TensorFlow for micro (MNIST digit classification) controllers on RPU

- Make sure to build platform by following this [README.md](../platform/README.md)

- TensorFlow Version: v2.4.1

***

## Create application

### Preparation

```shell-session
# set up toolchain
$ . <Vitis install directory>/Vitis/2024.1/settings64.sh

# clone TFLite Micro repo
$ git clone https://github.com/tensorflow/tflite-micro.git
$ pushd tflite-micro
$ git checkout 8f9a923ad306a2d298c5086b57ec9b6caca76dfd
$ popd
```

### Build TensorFlow micro static library

```shell-session
# start building static library
# release build will emit error on MicroPrintf()
$ make -j$(nproc) -f ./tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- COMMON_FLAGS="-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16 -std=c++14" BUILD_TYPE=release
$ popd
```

- Output static library can be found as ``tflite-micro/gen/linux_armv7r_release_gcc/lib/libtensorflow-microlite.a``

- Generate BOOT.bin

```shell-session
$ vitis -s create_mnist_app.py
$ bootgen -image tf_micro.bif -arch zynqmp -o BOOT.bin -w on
```

***

## TFLite micro testing app

- Build TFLite micro static library

```shell-session
# release build will emit error on MicroPrintf()
$ make -j$(nproc) -f ./tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- COMMON_FLAGS="-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16 -std=c++14" BUILD_TYPE=release_with_logs
$ popd
```

- Generate BOOT.bin

```shell-session
$ vitis -s create_testing_app.py
$ bootgen -image tf_micro.bif -arch zynqmp -o BOOT.bin -w on
```

- Run:
  - Copy the generated BOOB.bin into a micro SD card & boot up the board

```shell-session
Zynq MP First Stage Boot Loader 
Release 2024.1   Sep 16 2024  -  10:24:25
PMU-FW is not running, certain applications may not be supported.
Testing ArgumentsExecutedOnlyOnce
Testing TestExpectEQ
Testing TestExpectNE
3/3 tests passed
~~~ALL TESTS PASSED~~~
```
