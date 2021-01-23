# 
# Create hello world application for RPU
# 
set VITIS_DIR   _vitis
set PFM_NAME    u96v2_r5
set WORK_DIR [ file dirname [ file normalize [ info script ] ] ]

# Remove existing directory
file delete -force ${WORK_DIR}/${VITIS_DIR}

# Set up the environment
setws ${WORK_DIR}/${VITIS_DIR}
puts "\[INFO\] Workspace: [ getws ]"

puts "\[INFO\] Platform:"
puts [ platform list ]

# Create application
# '-arch' is not supported for application creation using platform/domain
app create -name {hello_world} -platform ${PFM_NAME} -domain {standalone_psu_cortexr5_0} -proc {psu_cortexr5_0} -template {Hello World} -os {standalone}
app config -name hello_world -set build-config release
app build -name hello_world

sysproj build -name hello_world_system
