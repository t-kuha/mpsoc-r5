# 
# Build TFLite Micro testing
# 
set PRJ_NAME    tflm_testing
set VITIS_DIR   _vitis_tflm_testing
set PFM_NAME    u96v2_r5
set WORK_DIR [ file dirname [ file normalize [ info script ] ] ]
set TFLM_REPO_PATH   ${WORK_DIR}/tflite-micro

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
file copy -force ${TFLM_REPO_PATH}/tensorflow/lite/micro/testing/micro_test.h       ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force ${TFLM_REPO_PATH}/tensorflow/lite/micro/testing/test_conv_model.cc ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force ${TFLM_REPO_PATH}/tensorflow/lite/micro/testing/test_conv_model.h  ${VITIS_DIR}/${PRJ_NAME}/src
file copy -force ${TFLM_REPO_PATH}/tensorflow/lite/micro/testing/util_test.cc       ${VITIS_DIR}/${PRJ_NAME}/src
app config -name ${PRJ_NAME} -set build-config release
# Add include path & static library
# Need to run this after changing "build-config"
app config -name ${PRJ_NAME} -add define-compiler-symbols "TF_LITE_STATIC_MEMORY"
app config -name ${PRJ_NAME} -set compiler-misc "-mcpu=cortex-r5 -mfloat-abi=hard -c -mfpu=vfpv3-d16"
app config -name ${PRJ_NAME} -add include-path "${TFLM_REPO_PATH}"
app config -name ${PRJ_NAME} -add include-path "${TFLM_REPO_PATH}/tensorflow/lite/micro/tools/make/downloads/"
app config -name ${PRJ_NAME} -add include-path "${TFLM_REPO_PATH}/tensorflow/lite/micro/tools/make/downloads/gemmlowp"
app config -name ${PRJ_NAME} -add include-path "${TFLM_REPO_PATH}/tensorflow/lite/micro/tools/make/downloads/flatbuffers/include"
app config -name ${PRJ_NAME} -add include-path "${TFLM_REPO_PATH}/tensorflow/lite/micro/tools/make/downloads/ruy"
app config -name ${PRJ_NAME} -add linker-misc "-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16"
app config -name ${PRJ_NAME} -add libraries "m"
app config -name ${PRJ_NAME} -add library-search-path "${TFLM_REPO_PATH}/gen/linux_armv7r_default/lib"
app config -name ${PRJ_NAME} -add libraries "tensorflow-microlite"
app build -name ${PRJ_NAME}

sysproj build -name ${PRJ_NAME}_system
