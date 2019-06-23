#!/bin/sh

set -eu

BASE_DIR=$(cd $(dirname $0) && pwd)

# Append extension (*.elf)
for f in $(ls tensorflow/tensorflow/lite/experimental/micro/tools/make/gen/zynq_x86_64/bin/*_test)
do
    cp ${f} ${f}.elf
done

# Create output directory
rm -rf ${BASE_DIR}/_bin
mkdir  ${BASE_DIR}/_bin

# Create BOOT.bin for each elf
for f in $(ls tensorflow/tensorflow/lite/experimental/micro/tools/make/gen/zynq_x86_64/bin/*_test.elf)
do
    # echo ${f}
    sed -ri s~'tensorflow\/tensorflow(.*)_test.elf$'~${f}~ ./src/boot_bin.bif

    xsct create_boot_bin.tcl

    mv BOOT.bin _bin/$(echo ${f} | cut -d '/' -f 11)_BOOT.bin
done 
