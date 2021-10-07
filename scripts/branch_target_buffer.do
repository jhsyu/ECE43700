onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /branch_target_buffer_tb/CLK
add wave -noupdate /branch_target_buffer_tb/nRST
add wave -noupdate -radix hexadecimal -childformat {{/branch_target_buffer_tb/btbif/rsel.ind -radix unsigned}} -expand -subitemconfig {/branch_target_buffer_tb/btbif/rsel.ind {-radix unsigned}} /branch_target_buffer_tb/btbif/rsel
add wave -noupdate -childformat {{/branch_target_buffer_tb/btbif/wsel.ind -radix unsigned}} -expand -subitemconfig {/branch_target_buffer_tb/btbif/wsel.ind {-radix unsigned}} /branch_target_buffer_tb/btbif/wsel
add wave -noupdate /branch_target_buffer_tb/btbif/wen
add wave -noupdate -expand /branch_target_buffer_tb/btbif/rdat
add wave -noupdate -expand /branch_target_buffer_tb/btbif/wdat
add wave -noupdate -expand /branch_target_buffer_tb/DUT/buffer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34 ns} 0}
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
WaveRestoreZoom {0 ns} {58 ns}
