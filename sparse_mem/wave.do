onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TEST /top/test_u/packet_arr
add wave -noupdate -expand -group CONTROL /top/clk_i
add wave -noupdate -expand -group CONTROL /top/rst_ni
add wave -noupdate -expand -group CONTROL /top/spmem_fu/cs_ni
add wave -noupdate -expand -group READING -itemcolor Cyan /top/spmem_fu/re_i
add wave -noupdate -expand -group READING -itemcolor Cyan -radix hexadecimal /top/spmem_fu/read_address_i
add wave -noupdate -expand -group READING -itemcolor Cyan -radix hexadecimal /top/spmem_fu/read_data_o
add wave -noupdate -expand -group READING -itemcolor Cyan -radix hexadecimal /top/spmem_u/read_data_o_wire
add wave -noupdate -expand -group READING -itemcolor Cyan -radix hexadecimal /top/spmem_u/read_data_o_reg
add wave -noupdate -expand -group READING -itemcolor Cyan /top/spmem_u/r_state_current
add wave -noupdate -expand -group READING -itemcolor Cyan /top/spmem_u/r_state_next
add wave -noupdate -expand -group WRITING -itemcolor Pink /top/spmem_fu/we_i
add wave -noupdate -expand -group WRITING -itemcolor Pink -radix hexadecimal /top/spmem_fu/write_address_i
add wave -noupdate -expand -group WRITING -itemcolor Pink -radix hexadecimal /top/spmem_fu/write_data_i
add wave -noupdate -expand -group WRITING -itemcolor Pink /top/spmem_u/write_address_i_reg
add wave -noupdate -expand -group WRITING -itemcolor Pink /top/spmem_u/w_state_current
add wave -noupdate -expand -group WRITING -itemcolor Pink /top/spmem_u/w_state_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {147840 ps} 0} {{Cursor 2} {1439200 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 234
configure wave -valuecolwidth 73
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1343480 ps} {1501800 ps}
