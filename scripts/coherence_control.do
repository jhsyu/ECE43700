onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /coherence_control_tb/CLK
add wave -noupdate /coherence_control_tb/nRST
add wave -noupdate /coherence_control_tb/PROG/test_case_num
add wave -noupdate /coherence_control_tb/PROG/test_case_info
add wave -noupdate -expand -group controller /coherence_control_tb/DUT/s
add wave -noupdate -expand -group controller /coherence_control_tb/DUT/prid
add wave -noupdate -expand -group controller /coherence_control_tb/DUT/daddr
add wave -noupdate -expand -group controller -expand /coherence_control_tb/DUT/dstore
add wave -noupdate -expand -group controller /coherence_control_tb/DUT/ramstate
add wave -noupdate -expand -group Cache -radix binary /coherence_control_tb/ccif/dwait
add wave -noupdate -expand -group Cache -radix binary /coherence_control_tb/ccif/dREN
add wave -noupdate -expand -group Cache -radix binary /coherence_control_tb/ccif/dWEN
add wave -noupdate -expand -group Cache -radix hexadecimal -childformat {{{/coherence_control_tb/ccif/dload[1]} -radix hexadecimal} {{/coherence_control_tb/ccif/dload[0]} -radix hexadecimal}} -expand -subitemconfig {{/coherence_control_tb/ccif/dload[1]} {-height 16 -radix hexadecimal} {/coherence_control_tb/ccif/dload[0]} {-height 16 -radix hexadecimal}} /coherence_control_tb/ccif/dload
add wave -noupdate -expand -group Cache -radix hexadecimal -childformat {{{/coherence_control_tb/ccif/dstore[1]} -radix hexadecimal} {{/coherence_control_tb/ccif/dstore[0]} -radix hexadecimal}} -expand -subitemconfig {{/coherence_control_tb/ccif/dstore[1]} {-height 16 -radix hexadecimal} {/coherence_control_tb/ccif/dstore[0]} {-height 16 -radix hexadecimal}} /coherence_control_tb/ccif/dstore
add wave -noupdate -expand -group Cache -radix hexadecimal /coherence_control_tb/ccif/daddr
add wave -noupdate -expand -group SYNC -radix binary /coherence_control_tb/ccif/ccwait
add wave -noupdate -expand -group SYNC -radix binary /coherence_control_tb/ccif/ccinv
add wave -noupdate -expand -group SYNC -radix binary /coherence_control_tb/ccif/ccwrite
add wave -noupdate -expand -group SYNC -radix binary /coherence_control_tb/ccif/cctrans
add wave -noupdate -expand -group SYNC /coherence_control_tb/ccif/ccsnoopaddr
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramWEN
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramREN
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramstate
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramaddr
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramstore
add wave -noupdate -expand -group RAM /coherence_control_tb/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163 ns} 0}
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
WaveRestoreZoom {0 ns} {285 ns}
