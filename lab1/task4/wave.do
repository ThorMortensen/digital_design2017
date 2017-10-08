onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Tb /testbench/clk
add wave -noupdate -expand -group Tb /testbench/reset
add wave -noupdate -expand -group Tb -radix decimal /testbench/AB
add wave -noupdate -expand -group Tb /testbench/req
add wave -noupdate -expand -group Tb -radix decimal /testbench/C
add wave -noupdate -expand -group Tb /testbench/ack
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/req
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/ack
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/ABorALU
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/LDA
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/LDB
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/alu_Z
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/alu_N
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/alu_FN
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/next_state
add wave -noupdate -expand -group FSM /testbench/GCD_module/u2/inst_fsm/state
add wave -noupdate -expand -group RegA /testbench/GCD_module/u2/inst_regA/en
add wave -noupdate -expand -group RegA -radix decimal /testbench/GCD_module/u2/inst_regA/data_in
add wave -noupdate -expand -group RegA -radix decimal /testbench/GCD_module/u2/inst_regA/data_out
add wave -noupdate -expand -group RegB /testbench/GCD_module/u2/inst_regB/en
add wave -noupdate -expand -group RegB -radix decimal /testbench/GCD_module/u2/inst_regB/data_in
add wave -noupdate -expand -group RegB -radix decimal /testbench/GCD_module/u2/inst_regB/data_out
add wave -noupdate -group mux -radix decimal /testbench/GCD_module/u2/inst_mux/data_in1
add wave -noupdate -group mux -radix decimal /testbench/GCD_module/u2/inst_mux/data_in2
add wave -noupdate -group mux /testbench/GCD_module/u2/inst_mux/s
add wave -noupdate -group mux -radix decimal /testbench/GCD_module/u2/inst_mux/data_out
add wave -noupdate -expand -group alu -radix decimal /testbench/GCD_module/u2/inst_alu/A
add wave -noupdate -expand -group alu -radix decimal /testbench/GCD_module/u2/inst_alu/B
add wave -noupdate -expand -group alu -radix decimal /testbench/GCD_module/u2/inst_alu/C
add wave -noupdate -expand -group alu /testbench/GCD_module/u2/inst_alu/fn
add wave -noupdate -expand -group alu /testbench/GCD_module/u2/inst_alu/Z
add wave -noupdate -expand -group alu /testbench/GCD_module/u2/inst_alu/N
add wave -noupdate -radix decimal /testbench/GCD_module/u2/C_intl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175346 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 129
configure wave -valuecolwidth 70
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
WaveRestoreZoom {158246 ps} {180314 ps}
