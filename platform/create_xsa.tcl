# Setting
set PRJ_DIR     _vivado
set PRJ_NAME    u96v2_r5
set BD_NAME     design_1
set SRC_DIR     src


# Remove existing directory
file delete -force ${PRJ_DIR}

# Create project
create_project ${PRJ_NAME} ${PRJ_DIR} -part xczu3eg-sbva484-1-e
set_property board_part em.avnet.com:ultra96v2:part0:1.0 [current_project]

# Create block design
source ${SRC_DIR}/bd.tcl

# Set top-level source
make_wrapper -files [get_files [current_bd_design].bd] -top
add_files -norecurse ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/hdl/${BD_NAME}_wrapper.v
set_property top ${BD_NAME}_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Generate block design
regenerate_bd_layout
save_bd_design
generate_target all [get_files [current_bd_design].bd]

# We do not have to generate bitstream

# Export HW
write_hw_platform -fixed -force -file ${PRJ_NAME}.xsa

# Finish - close project
close_project
