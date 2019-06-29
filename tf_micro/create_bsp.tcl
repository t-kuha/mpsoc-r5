# Create BOOT.bin (for standalone)
# 
# Usage: In Xilinx Software Command Line Tool, run the following command:
#           source create_boot_bin.tcl
# 
# Need to install board files in <SDK Installation Path>/data/boards/board_files
#
# Reference: UG1208
# 

set XSDK_DIR    _sdk
set PRJ_NAME    u96_tf
set SRC_DIR     src

set SCRIPT_DIR [ file dirname [ file normalize [ info script ] ] ]

cd ${SCRIPT_DIR}

setws ${SCRIPT_DIR}/${XSDK_DIR}

# Create BSP
createhw -name bsp -hwspec ${XSDK_DIR}/${PRJ_NAME}.hdf

# Create FSBL
createapp -name fsbl -app {Zynq MP FSBL} -hwproject bsp -proc psu_cortexr5_0 -os standalone

# Create application
createapp -name tf -app {Hello World} -hwproject bsp -proc psu_cortexr5_0 -os standalone

# Use UART1 as stdin & stdout 
configbsp -bsp fsbl_bsp stdin  "psu_uart_1"
configbsp -bsp fsbl_bsp stdout "psu_uart_1"
updatemss -mss ${XSDK_DIR}/fsbl_bsp/system.mss
regenbsp -bsp fsbl_bsp

configbsp -bsp tf_bsp stdin  "psu_uart_1"
configbsp -bsp tf_bsp stdout "psu_uart_1"
updatemss -mss ${XSDK_DIR}/tf_bsp/system.mss
regenbsp -bsp tf_bsp

# Build in release mode
configapp -app fsbl build-config release
configapp -app tf build-config release

projects -build
