onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Input /testbench/clk
add wave -noupdate -expand -group Input /testbench/reset
add wave -noupdate -expand -group Input -radix decimal /testbench/AB
add wave -noupdate -expand -group Input /testbench/req
add wave -noupdate -expand -group Input -radix decimal /testbench/C
add wave -noupdate -expand -group Input /testbench/ack
add wave -noupdate -radix decimal /testbench/GCD_module/u2/next_reg_a
add wave -noupdate -radix decimal /testbench/GCD_module/u2/reg_a
add wave -noupdate -radix decimal /testbench/GCD_module/u2/next_reg_b
add wave -noupdate -radix decimal /testbench/GCD_module/u2/reg_b
add wave -noupdate /testbench/GCD_module/u2/next_state
add wave -noupdate /testbench/GCD_module/u2/state
add wave -noupdate /testbench/GCD_module/u2/ack
add wave -noupdate -radix decimal /testbench/C
add wave -noupdate -radix decimal /testbench/GCD_module/u2/res
add wave -noupdate -radix decimal /testbench/GCD_module/u2/sum
add wave -noupdate -radix decimal /testbench/GCD_module/u2/swap_a_b
add wave -noupdate -radix decimal -childformat {{/testbench/GCD_module/u2/src0(16) -radix decimal} {/testbench/GCD_module/u2/src0(15) -radix decimal} {/testbench/GCD_module/u2/src0(14) -radix decimal} {/testbench/GCD_module/u2/src0(13) -radix decimal} {/testbench/GCD_module/u2/src0(12) -radix decimal} {/testbench/GCD_module/u2/src0(11) -radix decimal} {/testbench/GCD_module/u2/src0(10) -radix decimal} {/testbench/GCD_module/u2/src0(9) -radix decimal} {/testbench/GCD_module/u2/src0(8) -radix decimal} {/testbench/GCD_module/u2/src0(7) -radix decimal} {/testbench/GCD_module/u2/src0(6) -radix decimal} {/testbench/GCD_module/u2/src0(5) -radix decimal} {/testbench/GCD_module/u2/src0(4) -radix decimal} {/testbench/GCD_module/u2/src0(3) -radix decimal} {/testbench/GCD_module/u2/src0(2) -radix decimal} {/testbench/GCD_module/u2/src0(1) -radix decimal} {/testbench/GCD_module/u2/src0(0) -radix decimal}} -subitemconfig {/testbench/GCD_module/u2/src0(16) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(15) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(14) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(13) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(12) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(11) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(10) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(9) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(8) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(7) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(6) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(5) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(4) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(3) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(2) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(1) {-height 16 -radix decimal} /testbench/GCD_module/u2/src0(0) {-height 16 -radix decimal}} /testbench/GCD_module/u2/src0
add wave -noupdate -radix decimal /testbench/GCD_module/u2/src1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {117330 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
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
configure wave -timelineunits ns
update
WaveRestoreZoom {49884 ps} {256906 ps}
