#!/bin/bash


wbgen2 -V d3s_acq_buffer_wb.vhd -H record -p d3s_acq_buffer_wbgen2_pkg.vhd -K d3s_acq_buffer_wb.vh -s defines -C d3s_acq_buffer_wb.h -D d3s_acq_buffer_wb.html d3s_acq_buffer_wb.wb 
wbgen2 -V trigger_generator_wb.vhd -H record -p trigger_generator_wbgen2_pkg.vhd -K trigger_generator_wb.vh -s defines -C trigger_generator_wb.h -D trigger_generator_wb.html trigger_generator_wb.wb 
mv *_wb.vh ../../testbench/include