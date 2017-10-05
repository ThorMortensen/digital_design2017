onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Input /testbench/clk
add wave -noupdate -expand -group Input /testbench/reset
add wave -noupdate -expand -group Input -radix decimal /testbench/AB
add wave -noupdate -expand -group Input /testbench/req
add wave -noupdate -expand -group Input /testbench/C
add wave -noupdate -expand -group Input /testbench/ack
add wave -noupdate -radix decimal /testbench/GCD_module/u2/next_reg_a
add wave -noupdate -radix decimal /testbench/GCD_module/u2/reg_a
add wave -noupdate -radix decimal /testbench/GCD_module/u2/next_reg_b
add wave -noupdate -radix decimal /testbench/GCD_module/u2/reg_b
add wave -noupdate /testbench/GCD_module/u2/next_state
add wave -noupdate /testbench/GCD_module/u2/state
add wave -noupdate /testbench/GCD_module/u2/ack
add wave -noupdate /testbench/GCD_module/u2/calc_select
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {111616 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
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
WaveRestoreZoom {87455 ps} {135777 ps}
