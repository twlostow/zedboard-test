onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/rst_n_i
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/clk_adc_i
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/serdes_data_raw_i
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/ch_a_data_o
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/ch_b_data_o
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/ch_c_data_o
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/ch_d_data_o
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/bitslip_o
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/serdes_out_data
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/serdes_out_fr
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/serdes_synced
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/serdes_bitslip
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/count
add wave -noupdate -expand -group UnpackAlign /main/DUT/U_UnpackAndAlign/test
add wave -noupdate -expand -group Top /main/DUT/clk_sys_i
add wave -noupdate -expand -group Top /main/DUT/rst_n_i
add wave -noupdate -expand -group Top /main/DUT/adc_dco_p_i
add wave -noupdate -expand -group Top /main/DUT/adc_dco_n_i
add wave -noupdate -expand -group Top /main/DUT/adc_fco_p_i
add wave -noupdate -expand -group Top /main/DUT/adc_fco_n_i
add wave -noupdate -expand -group Top /main/DUT/adc_d_p_i
add wave -noupdate -expand -group Top /main/DUT/adc_d_n_i
add wave -noupdate -expand -group Top /main/DUT/slave_i
add wave -noupdate -expand -group Top /main/DUT/slave_o
add wave -noupdate -expand -group Top /main/DUT/serdes_data_raw
add wave -noupdate -expand -group Top /main/DUT/clk_adc
add wave -noupdate -expand -group Top /main/DUT/rst_adc
add wave -noupdate -expand -group Top /main/DUT/rst_n_adc
add wave -noupdate -expand -group Top /main/DUT/wb_slave_in
add wave -noupdate -expand -group Top /main/DUT/wb_slave_out
add wave -noupdate /main/DUT/rst_adc
add wave -noupdate /main/DUT/rst_adc_serdes
add wave -noupdate -expand -subitemconfig {/main/DUT/ch_data(0) {-format Analog-Step -height 84 -max 8184.0 -min -8192.0}} /main/DUT/ch_data
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/clk_sys_i
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/rst_n_i
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/axi4_slave_i
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/axi4_slave_o
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/wb_master_o
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/wb_master_i
add wave -noupdate -group Bridge -height 16 /main/DUT/xwb_axi4lite_bridge_1/state
add wave -noupdate -group Bridge /main/DUT/xwb_axi4lite_bridge_1/count
add wave -noupdate -format Analog-Step -height 100 -max 1.0 -min -1.0 /main/v_in
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/rst_n_i
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/clk_adc_i
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/serdes_data_raw_i
add wave -noupdate -group Unpack -format Analog-Step -height 84 -max 4641.0 -min -3614.0 /main/DUT/U_UnpackAndAlign/ch_a_data_o
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/ch_b_data_o
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/ch_c_data_o
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/ch_d_data_o
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/bitslip_o
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/serdes_out_data
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/serdes_out_fr
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/serdes_synced
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/serdes_bitslip
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/count
add wave -noupdate -group Unpack /main/DUT/U_UnpackAndAlign/test
add wave -noupdate /main/DUT/cnx_master_out
add wave -noupdate /main/DUT/cnx_master_in
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/clk_adc_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/clk_sys_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/rst_n_sys_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/rst_n_adc_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/samples_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/slave_i
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/slave_o
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/trig_bus_o
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/x
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/thr_lo
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/thr_hi
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/regs_out
add wave -noupdate -group Trigger0 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/regs_in
add wave -noupdate -group Trigger0 -height 16 /main/DUT/gen_triggers_and_buffers(0)/U_trigger_generator_CHx/state
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/rst_n_sys_i
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/clk_sys_i
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/clk_acq_i
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/trigger_i
add wave -noupdate -expand -group Buffer0 -format Analog-Step -height 84 -max 8184.0 -min -8192.0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/data_i
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/slave_i
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/slave_o
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/wr_addr
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/wr_addr_last
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/done
add wave -noupdate -expand -group Buffer0 -expand -subitemconfig {/main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/regs_in.data_i {-format Analog-Step -height 84 -max 65528.0}} /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/regs_in
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/regs_out
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/acq_in_progress
add wave -noupdate -expand -group Buffer0 /main/DUT/gen_triggers_and_buffers(0)/U_Buf_CHx/triggered
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31026362 ps} 0}
configure wave -namecolwidth 281
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {30159418 ps} {31893306 ps}
