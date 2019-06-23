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

***

## Get TensorFlow source

- commit: f9dd464df8e2b51b1d9020f2d8799ca3ae4f8ef4

```shell-session
$ git clone https://github.com/tensorflow/tensorflow.git
$ cd tensorflow
$ git checkout f9dd464df8e2b51b1d9020f2d8799ca3ae4f8ef4
```

***

## Build

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
xsct% exec bootgen -arch zynqmp -image src/boot_bin_micro_features_fft_test.bif -w -o BOOT.bin
```

***

## Run

- Copy BOOT.bin into a micro SD card

***

## Reference

- https://github.com/tensorflow/tensorflow/tree/master/tensorflow/lite/experimental/micro

- https://forums.xilinx.com/t5/Embedded-Linux/Cross-compiling-gsl-library-to-ZYnq-board-on-ubuntu-16-04/td-p/772043
