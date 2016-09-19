set_property PACKAGE_PIN M14 [get_ports led0_o]
set_property IOSTANDARD LVCMOS25 [get_ports led0_o]
set_property PACKAGE_PIN M15 [get_ports led1_o]
set_property IOSTANDARD LVCMOS25 [get_ports led1_o]


set_property PACKAGE_PIN U18 [get_ports adc_fco_p_i]
set_property PACKAGE_PIN T14 [get_ports {adc_d_p_i[7]}]
set_property PACKAGE_PIN Y16 [get_ports {adc_d_p_i[6]}]
set_property PACKAGE_PIN T16 [get_ports {adc_d_p_i[5]}]
set_property PACKAGE_PIN N18 [get_ports {adc_d_p_i[4]}]
set_property PACKAGE_PIN T20 [get_ports {adc_d_p_i[3]}]
set_property PACKAGE_PIN Y18 [get_ports {adc_d_p_i[2]}]
set_property PACKAGE_PIN R16 [get_ports {adc_d_p_i[1]}]
set_property PACKAGE_PIN V17 [get_ports {adc_d_p_i[0]}]


set_property PACKAGE_PIN N17 [get_ports adc_cs_o]
set_property IOSTANDARD LVCMOS25 [get_ports adc_cs_o]
set_property PACKAGE_PIN N20 [get_ports adc_sdata_b]
set_property IOSTANDARD LVCMOS25 [get_ports adc_sdata_b]
set_property PACKAGE_PIN P20 [get_ports adc_sclk_o]
set_property IOSTANDARD LVCMOS25 [get_ports adc_sclk_o]



####################################################################################
# Constraints from file : 'constr_1.xdc'
####################################################################################

#set_property IOSTANDARD MINI_LVDS_25 [get_ports adc_dco_p_i]
set_property PACKAGE_PIN U14 [get_ports adc_dco_p_i]

create_clock -period 2.500 -name adc_dco_p_i -waveform {0.000 1.250} [get_ports adc_dco_p_i]
create_clock -period 10.000 -name {xprocessing_system_zedboard_1/U_Wrapped_PS/inst/FCLK_CLK_unbuffered[0]} -waveform {0.000 5.000} [get_pins {xprocessing_system_zedboard_1/U_Wrapped_PS/inst/PS7_i/FCLKCLK[0]}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
