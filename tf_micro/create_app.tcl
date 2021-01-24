# 
# Create hello world application for RPU
# 
set PRJ_NAME    tf_micro
set VITIS_DIR   _vitis
set PFM_NAME    u96v2_r5
set TF_VERSION  2.4.1
set WORK_DIR [ file dirname [ file normalize [ info script ] ] ]

# Remove existing directory
file delete -force ${WORK_DIR}/${VITIS_DIR}

# Set up the environment
setws ${WORK_DIR}/${VITIS_DIR}
puts "\[INFO\] Workspace: [ getws ]"

puts "\[INFO\] Platform:"
puts [ platform list ]

# Create application
app create -name ${PRJ_NAME} -sysproj ${PRJ_NAME}_system -platform ${PFM_NAME} \
-domain {standalone_psu_cortexr5_0} -proc {psu_cortexr5_0} \
-template {Empty Application (C++)} -os {standalone} -lang {c++}
# Copy source files
file copy -force src/main.cc        ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force src/model_quant.cc ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force src/model_quant.h  ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force src/data.h         ${VITIS_DIR}/${PRJ_NAME}/src
app config -name ${PRJ_NAME} -set build-config release
# Add include path & static library
# Need to run this after changing "build-config"
app config -name ${PRJ_NAME} -add define-compiler-symbols "TF_LITE_STATIC_MEMORY"
app config -name ${PRJ_NAME} -set compiler-misc "-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16"
app config -name ${PRJ_NAME} -add include-path "${WORK_DIR}/tensorflow-${TF_VERSION}"
app config -name ${PRJ_NAME} -add include-path "${WORK_DIR}/tensorflow-${TF_VERSION}/tensorflow/lite/micro/tools/make/downloads/"
app config -name ${PRJ_NAME} -add include-path "${WORK_DIR}/tensorflow-${TF_VERSION}/tensorflow/lite/micro/tools/make/downloads/gemmlowp"
app config -name ${PRJ_NAME} -add include-path "${WORK_DIR}/tensorflow-${TF_VERSION}/tensorflow/lite/micro/tools/make/downloads/flatbuffers/include"
app config -name ${PRJ_NAME} -add include-path "${WORK_DIR}/tensorflow-${TF_VERSION}/tensorflow/lite/micro/tools/make/downloads/ruy"
app config -name ${PRJ_NAME} -add linker-misc "-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16"
app config -name ${PRJ_NAME} -add libraries "m"
app config -name ${PRJ_NAME} -add library-search-path "${WORK_DIR}/tensorflow-${TF_VERSION}/tensorflow/lite/micro/tools/make/gen/linux_armv7r/lib"
app config -name ${PRJ_NAME} -add libraries "tensorflow-microlite"
app build -name ${PRJ_NAME}

sysproj build -name ${PRJ_NAME}_system
