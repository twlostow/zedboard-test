## vlog -sv main.sv +incdir+. +incdir+../../include/wb +incdir+../../include/vme64x_bfm +incdir+../../include +incdir+../include +incdir+../../sim
vsim -t 1ps work.main work.glbl -voptargs=+acc -L unisims_ver -L secureip

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

do wave.do
radix -hexadecimal
run 80us
