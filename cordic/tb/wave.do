onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/clk
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/rst
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/valid_read
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/valid_write
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/cosine
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/sine
add wave -noupdate -expand -group TB -color Gold -itemcolor Gold /cordic_tb/angle
add wave -noupdate -expand -group TOP -color {Medium Spring Green} -itemcolor {Medium Spring Green} /cordic_tb/cordic_top/x_start
add wave -noupdate -expand -group TOP -color {Medium Spring Green} -itemcolor {Medium Spring Green} /cordic_tb/cordic_top/y_start
add wave -noupdate -expand -group TOP -color {Medium Spring Green} -itemcolor {Medium Spring Green} /cordic_tb/cordic_top/atan_lut
add wave -noupdate -expand -group TOP -color {Medium Spring Green} -itemcolor {Medium Spring Green} /cordic_tb/cordic_top/iter
add wave -noupdate -expand -group TOP -color {Medium Spring Green} -itemcolor {Medium Spring Green} /cordic_tb/cordic_top/start
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/angle_corrected_1
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/angle_corrected_2
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/angle_acc_current
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/angle_acc_next
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/x_cos_current
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/y_sin_current
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/x_cos_next
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/y_sin_next
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/sign_cos
add wave -noupdate -expand -group CORDIC -color Violet -itemcolor Violet /cordic_tb/cordic_top/cordic/direction
add wave -noupdate -expand -group ROM -color {Lime Green} -itemcolor {Lime Green} /cordic_tb/cordic_top/atan_lut_rom/rom
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 290
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {4331250 ps}
