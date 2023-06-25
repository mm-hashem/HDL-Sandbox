vlib work
vlog alu.v alu_tb.sv +cover -covercells
vsim -voptargs=+acc work.alu_tb -cover
add wave *
coverage save alu_tb.ucdb
run -all
