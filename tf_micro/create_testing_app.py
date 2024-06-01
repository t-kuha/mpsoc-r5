"""
Create hello world application for RPU.
"""
import os
import shutil
import vitis


PFM_NAME='u96v2_r5'
TOP_DIR=os.path.dirname(os.path.abspath(__file__))
PFM_PATH=os.path.join(
    os.path.dirname(TOP_DIR), 'platform', '_pfm', PFM_NAME, 'export', PFM_NAME, f'{PFM_NAME}.xpfm'
)
WORKSPACE=os.path.join(TOP_DIR, '_vitis')
TFLM_REPO_PATH=os.path.join(TOP_DIR, 'tflite-micro')

assert os.path.exists(TFLM_REPO_PATH)
if os.path.exists(WORKSPACE):
    print('[INFO] removing existing workspace...')
    shutil.rmtree(WORKSPACE)

client = vitis.create_client()
client.set_workspace(path=WORKSPACE)

comp = client.create_app_component(
    name='tflm_testing',
    platform=PFM_PATH,
    domain='standalone_psu_cortexr5_0',
    # template='empty'
)

# copy source files
SRC_NAMES = ['micro_test.h', 'test_conv_model.cc', 'test_conv_model.h', 'util_test.cc']
for src_name in SRC_NAMES:
    shutil.copy(
        os.path.join(TFLM_REPO_PATH, 'tensorflow', 'lite', 'micro', 'testing', src_name),
        os.path.join(WORKSPACE, 'tflm_testing', 'src', src_name)
    )

# ‘USER_COMPILE_DEFINITIONS’,’USER_LINK_LIBRARIES’ ,’USER_UNDEFINE_SYMBOLS’,’USER_INCLUDE_DIRECTORIES’
status = comp.set_app_config(key='USER_COMPILE_DEFINITIONS', values=['TF_LITE_STATIC_MEMORY'])
status = comp.set_app_config(
    key='USER_LINK_LIBRARIES',
    values=[
        'm',
        # , 'libtensorflow-microlite.a')
        'tensorflow-microlite',
    ]
)
# status = comp.set_app_config(key='USER_UNDEFINE_SYMBOLS', values=[])
# status = comp.set_app_config(key='USER_COMPILE_OPTIONS', values=['-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16'])
# status = comp.set_app_config(key='USER_COMPILE_OPTIONS', values=['-mcpu=cortex-r5', '-mfloat-abi=hard', '-mfpu=vfpv3-d16'])
# status = comp.set_app_config(key='USER_LINK_OPTIONS', values=['-mcpu=cortex-r5', '-mfloat-abi=hard', '-mfpu=vfpv3-d16'])
# status = comp.set_app_config(key='USER_LINK_OPTIONS', values=['-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16'])
status = comp.set_app_config(key='USER_LINK_DIRECTORIES', values=[os.path.join(TFLM_REPO_PATH, 'gen', 'linux_armv7r_default_gcc', 'lib')])
status = comp.set_app_config(
    key='USER_INCLUDE_DIRECTORIES',
    values=[
        TFLM_REPO_PATH,
        os.path.join(TFLM_REPO_PATH, 'tensorflow', 'lite', 'micro', 'tools', 'make', 'downloads'),
        os.path.join(TFLM_REPO_PATH, 'tensorflow', 'lite', 'micro', 'tools', 'make', 'downloads', 'gemmlowp'),
        os.path.join(TFLM_REPO_PATH, 'tensorflow', 'lite', 'micro', 'tools', 'make', 'downloads', 'flatbuffers', 'include'),
        os.path.join(TFLM_REPO_PATH, 'tensorflow', 'lite', 'micro', 'tools', 'make', 'downloads', 'ruy')
    ]
)
# app config -name ${PRJ_NAME} -set compiler-misc ""
# app config -name ${PRJ_NAME} -add linker-misc "-mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16"
# app config -name ${PRJ_NAME} -add library-search-path "${TFLM_REPO_PATH}/gen/linux_armv7r_default/lib"


comp.build()

vitis.dispose()
