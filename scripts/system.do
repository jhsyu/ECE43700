onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/PROG/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group DC0 /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -expand -group DC0 -color {Cornflower Blue} /system_tb/DUT/CPU/DP0/mem_opcode
add wave -noupdate -expand -group DC0 -color {Cornflower Blue} /system_tb/DUT/CPU/DP0/rif/ex_mem_out.imemload
add wave -noupdate -expand -group DC0 -radix binary {/system_tb/DUT/CPU/ccif/dWEN[0]}
add wave -noupdate -expand -group DC0 -radix binary {/system_tb/DUT/CPU/ccif/dwait[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/CC/daddr[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/CC/dstore[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/ccif/dload[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/ccif/ccwrite[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/ccif/cctrans[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/ccif/ccwait[0]}
add wave -noupdate -expand -group DC0 {/system_tb/DUT/CPU/ccif/ccsnoopaddr[0]}
add wave -noupdate -expand -group DC0 /system_tb/DUT/CPU/CM0/DCACHE/set
add wave -noupdate -expand -group DC0 -color Violet /system_tb/DUT/CPU/CM0/DCACHE/ds
add wave -noupdate -expand -group DC1 /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate -expand -group DC1 -color {Cornflower Blue} /system_tb/DUT/CPU/DP1/mem_opcode
add wave -noupdate -expand -group DC1 -color {Cornflower Blue} /system_tb/DUT/CPU/DP1/rif/ex_mem_out.imemload
add wave -noupdate -expand -group DC1 -radix binary {/system_tb/DUT/CPU/ccif/dWEN[1]}
add wave -noupdate -expand -group DC1 -radix binary {/system_tb/DUT/CPU/ccif/dwait[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/CC/daddr[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/ccif/dload[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/CC/dstore[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/ccif/ccwrite[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/ccif/cctrans[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/ccif/ccwait[1]}
add wave -noupdate -expand -group DC1 {/system_tb/DUT/CPU/ccif/ccsnoopaddr[1]}
add wave -noupdate -expand -group DC1 /system_tb/DUT/CPU/CM1/DCACHE/set
add wave -noupdate -expand -group DC1 -color Violet /system_tb/DUT/CPU/CM1/DCACHE/ds
add wave -noupdate -expand -group CC -color Violet /system_tb/DUT/CPU/CC/s
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/prid
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/nxt_prid
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1534667 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
configure wave -valuecolwidth 146
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
WaveRestoreZoom {901200 ps} {1652200 ps}
