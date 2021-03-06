onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /register_file_tb/PROG/#ublk#502948#66/test_case_num
add wave -noupdate /register_file_tb/CLK
add wave -noupdate /register_file_tb/nRST
add wave -noupdate -radix unsigned /register_file_tb/v1
add wave -noupdate -radix unsigned /register_file_tb/v2
add wave -noupdate -radix unsigned /register_file_tb/v3
add wave -noupdate /register_file_tb/DUT/test_probe
add wave -noupdate /register_file_tb/rfif/WEN
add wave -noupdate /register_file_tb/rfif/wsel
add wave -noupdate -radix unsigned /register_file_tb/rfif/wdat
add wave -noupdate -expand -group {$0} -radix decimal {/register_file_tb/DUT/reg_curr[0]}
add wave -noupdate -expand -group {$0} -radix unsigned {/register_file_tb/DUT/reg_next[0]}
add wave -noupdate -expand -group {$1} -radix unsigned {/register_file_tb/DUT/reg_curr[1]}
add wave -noupdate -expand -group {$1} -radix unsigned {/register_file_tb/DUT/reg_next[1]}
add wave -noupdate -expand -group {$31} -radix unsigned {/register_file_tb/DUT/reg_curr[31]}
add wave -noupdate -expand -group {$31} -radix unsigned {/register_file_tb/DUT/reg_next[31]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {95 ns}
