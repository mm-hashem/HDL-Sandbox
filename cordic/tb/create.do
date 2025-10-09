vlib work
vlog ../rtl/*.v
vlog *.v
vsim -voptargs=+acc work.cordic_tb
do wave.do
run -all