"""
Create platform.
"""
import os
import shutil
import vitis


TOP_DIR=os.path.dirname(os.path.abspath(__file__))

# platform info
PFM_DIR=os.path.join(TOP_DIR, '_pfm')
PFM_NAME='u96v2_r5'

if os.path.exists(PFM_DIR):
    print('[INFO] removing existing directory...')
    shutil.rmtree(PFM_DIR)

client = vitis.create_client()
client.set_workspace(path=PFM_DIR)

platform = client.create_platform_component(
    name=PFM_NAME,
    desc='Ultra96 v2 ARM Cortex-R5 platform',
    hw_design=os.path.join(TOP_DIR, f'{PFM_NAME}.xsa'),
    os='standalone',
    cpu='psu_cortexr5_0',
    domain_name='standalone_psu_cortexr5_0',
    no_boot_bsp=True,
    is_pmufw_req=True
)

platform = client.get_component(name=PFM_NAME)
status = platform.generate_boot_bsp(target_processor='psu_cortexr5_0')

domain = platform.get_domain(name='standalone_psu_cortexr5_0')
status = domain.set_config(option='os', param='standalone_stdin', value='psu_uart_1')
status = domain.set_config(option='os', param='standalone_stdout', value='psu_uart_1')

domain = platform.get_domain(name='zynqmp_pmufw')
status = domain.set_config(option='os', param='standalone_stdin', value='psu_uart_1')
status = domain.set_config(option='os', param='standalone_stdout', value='psu_uart_1')

domain = platform.get_domain(name='zynqmp_fsbl')
status = domain.set_config(option='os', param='standalone_stdin', value='psu_uart_1')
status = domain.set_config(option='os', param='standalone_stdout', value='psu_uart_1')

status = platform.build()

vitis.dispose()
