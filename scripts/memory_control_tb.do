onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/mytest/test_case_num
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramstate
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramREN
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramWEN
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramaddr
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramload
add wave -noupdate -expand -group RAM /memory_control_tb/prif/ramaddr
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/iwait
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/dwait
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/iREN
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/dREN
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/dWEN
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/iload
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/dload
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/dstore
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/iaddr
add wave -noupdate -expand -group CIF0 /memory_control_tb/cif0/daddr
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/iwait
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/dwait
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/iREN
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/dREN
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/dWEN
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/iload
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/dload
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/dstore
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/iaddr
add wave -noupdate -expand -group CCIF /memory_control_tb/ccif/daddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16281 ps} 0}
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
WaveRestoreZoom {0 ps} {123 ns}
