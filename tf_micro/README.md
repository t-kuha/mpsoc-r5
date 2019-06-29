# TensorFlow for micro controllers on RPU

- OS: Ubuntu 16:04
- Toolchain: 2018.3
- Board: Ultra96 (v1)

***

## Generate FSBL & BSP

- Generate HW

```shell-session
$ vivado -mode batch -source create_vivado_project.tcl
```

- Create BSP (for FSBL & App)

```shell-session
xsct% source create_bsp.tcl
```

- Increase stack size in _tf_micro/sdk/tf/src/lscript.ld_ to 0x40000

***

## Get TensorFlow source

- We will use commit _f9dd464df8e2b51b1d9020f2d8799ca3ae4f8ef4_

```shell-session
$ git clone https://github.com/tensorflow/tensorflow.git
$ cd tensorflow
$ git checkout f9dd464df8e2b51b1d9020f2d8799ca3ae4f8ef4
```

***

## TF micro tests

### Build

- Edit Makefile (tensorflow/tensorflow/lite/experimental/micro/tools/make/Makefile)

  - Before

  ```Makefile
  LDOPTS := -L/usr/local/lib
  ```

  - After

  ```Makefile
  LDFLAGS := -L/usr/local/lib
  ```

- Make static library

```shell-session
$ make -j$(nproc) -f tensorflow/lite/experimental/micro/tools/make/Makefile \
TARGET=zynq TAGS=arm \
TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- \
CXXFLAGS="-O3 -DNDEBUG -DTF_LITE_STATIC_MEMORY -DARMR5 -Wall -fmessage-length=0 -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" \
CCFLAGS="-O3 -DNDEBUG -g -DTF_LITE_STATIC_MEMORY -DARMR5 -Wall -fmessage-length=0 -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" \
microlite
```

- Make test applications

```shell-session
make -j$(nproc) -f tensorflow/lite/experimental/micro/tools/make/Makefile \
TARGET=zynq TAGS=arm \
TARGET_TOOLCHAIN_PREFIX=armr5-none-eabi- \
CXXFLAGS="-O3 -DNDEBUG -DTF_LITE_STATIC_MEMORY -DARMR5 -Wall -fmessage-length=0 -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" \
CCFLAGS="-O3 -DNDEBUG -g -DTF_LITE_STATIC_MEMORY -DARMR5 -Wall -fmessage-length=0 -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16" \
LDFLAGS="-Wl,--start-group,-lgcc,-lc,-lstdc++,-lm,--end-group -Wl,-T -Wl,../sdk/tf/src/lscript.ld ../sdk/tf_bsp/psu_cortexr5_0/lib/libxil.a" \
test
```

- Make BOOT.bin

```shell-session
$ cd ..
% ./create_boot_bin.sh
```

### Run tests

- Copy BOOT.bin into a micro SD card

- Example output (command_responder_test):

```shell-session
Xilinx Zynq MP First Stage Boot Loader
Release 2018.3   Jun 22 2019  -  19:03:28
PMU-FW is not running, certain applications may not be supported.
Testing TestCallability
Heard foo (0) @0ms
1/1 tests passed
~~~ALL TESTS PASSED~~~
```

***

## MNIST application

### Build

```shell-session
$ mkdir _app_mnist

# Compile
$ armr5-none-eabi-g++ \
-c -O3 -DNDEBUG -DTF_LITE_STATIC_MEMORY -DARMR5 \
-Wall -fmessage-length=0 -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16 \
-Isrc/app_mnist \
-Itensorflow \
-Itensorflow/tensorflow/lite/experimental/micro/tools/make/downloads/ \
-Itensorflow/tensorflow/lite/experimental/micro/tools/make/downloads/gemmlowp \
-Itensorflow/tensorflow/lite/experimental/micro/tools/make/downloads/flatbuffers/include \
src/app_mnist/main.cpp -o _app_mnist/main.o

# Link
armr5-none-eabi-g++ \
-Wl,-T -Wl,_sdk/tf/src/lscript.ld \
-o _app_mnist/tf_micro.elf \
_app_mnist/main.o \
tensorflow/tensorflow/lite/experimental/micro/tools/make/gen/zynq_x86_64/lib/libtensorflow-microlite.a \
-lm -Wl,--start-group,-lgcc,-lc,-lstdc++,--end-group \
_sdk/tf_bsp/psu_cortexr5_0/lib/libxil.a \
-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16
```

- Create BOOT.bin

```shell-session
xsct% exec bootgen -arch zynqmp -image src/boot_bin_mnist_app.bif -w -o BOOT.bin
```

### Run

- Output:

```shell-session
Xilinx Zynq MP First Stage Boot Loader
Release 2018.3   Jun 21 2019  -  20:14:26
PMU-FW is not running, certain applications may not be supported.
..... TensorFlow Lite for Micro Controllers .....
TF version: 1.13.1
Score: 1.11092e-11
Score: 8.0648e-15
Score: 1.88969e-09
Score: 3.409e-08
Score: 1.40475e-14
Score: 1.13911e-10
Score: 1.89212e-22
Score: 1
Score: 6.73126e-12
Score: 4.93872e-08
Output: 7
```

***

## Reference

- https://github.com/tensorflow/tensorflow/tree/master/tensorflow/lite/experimental/micro

- https://forums.xilinx.com/t5/Embedded-Linux/Cross-compiling-gsl-library-to-ZYnq-board-on-ubuntu-16-04/td-p/772043
