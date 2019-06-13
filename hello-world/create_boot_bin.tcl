# Create BOOT.bin (for standalone)
# 
# Usage: In Xilinx Software Command Line Tool, run the following command:
#           source create_boot_bin.tcl
# 
# Need to install board files in <SDK Installation Path>/data/boards/board_files
#
# Reference: UG1208
# 

set XSDK_DIR    sdk
set PRJ_NAME    u96_r5
set SRC_DIR     src

set SCRIPT_DIR [ file dirname [ file normalize [ info script ] ] ]

cd ${SCRIPT_DIR}

setws ${SCRIPT_DIR}/${XSDK_DIR}

# Create BSP
createhw -name bsp -hwspec ${XSDK_DIR}/${PRJ_NAME}.hdf

# Create FSBL
createapp -name fsbl -app {Zynq MP FSBL} -hwproject bsp -proc psu_cortexr5_0 -os standalone

# Create PMU FW
# createapp -name pmufw -app {ZynqMP PMU Firmware} -hwproject bsp -proc psu_pmu_0 -os standalone

# Create application
createapp -name hello_world -app {Hello World} -hwproject bsp -proc psu_cortexr5_0 -os standalone

# Use UART1 as stdin & stdout 
configbsp -bsp fsbl_bsp stdin  "psu_uart_1"
configbsp -bsp fsbl_bsp stdout "psu_uart_1"
updatemss -mss ${XSDK_DIR}/fsbl_bsp/system.mss
regenbsp -bsp fsbl_bsp

# configbsp -bsp pmufw_bsp stdin  "psu_uart_1"
# configbsp -bsp pmufw_bsp stdout "psu_uart_1"
# updatemss -mss ${XSDK_DIR}/pmufw_bsp/system.mss
# regenbsp -bsp pmufw_bsp

configbsp -bsp hello_world_bsp stdin  "psu_uart_1"
configbsp -bsp hello_world_bsp stdout "psu_uart_1"
updatemss -mss ${XSDK_DIR}/hello_world_bsp/system.mss
regenbsp -bsp hello_world_bsp

# Replace helloworld.c with led_blink.c
exec rm ${XSDK_DIR}/hello_world/${SRC_DIR}/helloworld.c
exec cp ${SRC_DIR}/helloworld.c ${XSDK_DIR}/hello_world/${SRC_DIR}/helloworld.c

# Build in release mode
configapp -app fsbl build-config release
# configapp -app pmufw build-config release
configapp -app hello_world build-config release

projects -build

# Generate BOOT.bin
exec bootgen -arch zynqmp -image ${SRC_DIR}/boot_bin.bif -w -o BOOT.bin
