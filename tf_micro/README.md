# TensorFlow Lite for micro controllers on RPU

- Make sure to build platform by following this [README.md](../platform/README.md)

***

## Preparation

```shell-session
# set up toolchain
$ . <Vitis install directory>/Vitis/2024.1/settings64.sh

# clone TFLite Micro repo
$ git clone https://github.com/tensorflow/tflite-micro.git
$ pushd tflite-micro
$ git checkout 8f9a923ad306a2d298c5086b57ec9b6caca76dfd
$ popd
```

## Build TFLite Micro static library

```shell-session
# release build will emit error on MicroPrintf()
$ make -j$(nproc) -f ./tensorflow/lite/micro/tools/make/Makefile TARGET_ARCH=armv7r TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- ADDITIONAL_DEFINES="-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" BUILD_TYPE=release_with_logs
$ popd
```

- Output static library can be found as ``tflite-micro/gen/linux_armv7r_release_with_logs_gcc/lib/libtensorflow-microlite.a``

## Build application - MNIST inference

- Generate BOOT.bin

```shell-session
$ vitis -s create_mnist_app.py
$ bootgen -image tf_micro.bif -arch zynqmp -o BOOT.bin -w on
```

- Copy the generated BOOB.bin into a micro SD card & boot up the board

```shell-session
Zynq MP First Stage Boot Loader 
Release 2024.1   Sep 16 2024  -  10:24:25
PMU-FW is not running, certain applications may not be supported.
..... TensorFlow Lite for Micro Controllers ...
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

## Build application - TFLite micro testing app

- Generate BOOT.bin

```shell-session
$ vitis -s create_testing_app.py
$ bootgen -image tf_micro.bif -arch zynqmp -o BOOT.bin -w on
```

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
