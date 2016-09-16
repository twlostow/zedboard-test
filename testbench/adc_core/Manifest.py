sim_tool = "modelsim"
top_module="main"
action = "simulation"
target = "xilinx"
fetchto = "../../ip_cores"
vcom_opt="-mixedsvvh l"

syn_device="xc6slx150t"
include_dirs=["../../sim", "../include"]

files = [ "main.sv", "glbl.v" ]

modules = { "local" :  [ "../../rtl/adc_core","../../ip_cores/general-cores" ] }

