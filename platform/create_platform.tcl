# 
# Create Vitis Platform
# 

set PFM_DIR   _pfm
set PFM_NAME  u96v2_r5

# Remove existing directory
file delete -force ${PFM_DIR}

# Generate platform
platform create -name ${PFM_NAME} -hw ${PFM_NAME}.xsa -fsbl-target {psu_cortexr5_0} -out ${PFM_DIR}
platform write
domain create -name {standalone_psu_cortexr5_0} -display-name {standalone_psu_cortexr5_0} -os {standalone} -proc {psu_cortexr5_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform write
platform active ${PFM_NAME}
domain active {zynqmp_fsbl}
bsp config stdin "psu_uart_1"
bsp config stdout "psu_uart_1"
bsp write
domain active {zynqmp_pmufw}
bsp config stdin "psu_uart_1"
bsp config stdout "psu_uart_1"
bsp write
domain active {standalone_psu_cortexr5_0}
bsp config stdin "psu_uart_1"
bsp config stdout "psu_uart_1"
bsp write
platform generate
