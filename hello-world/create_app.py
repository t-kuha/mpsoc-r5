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

if os.path.exists(WORKSPACE):
    print('[INFO] removing existing workspace...')
    shutil.rmtree(WORKSPACE)

client = vitis.create_client()
client.set_workspace(path=WORKSPACE)

comp = client.create_app_component(
    name='hello_world',
    platform=PFM_PATH,
    domain='standalone_psu_cortexr5_0',
    template='hello_world'
)

comp.build()

vitis.dispose()
