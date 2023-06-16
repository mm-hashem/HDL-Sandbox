vlib work
vlog psqwg.v psqwg_tb.v +cover -covercells
vsim -voptargs=+acc work.psqwg_tb -cover
add wave *
coverage save psqwg_tb.ucdb -onexit
run -all

//vcover report psqwg_tb.ucdb -details -annotate -all
