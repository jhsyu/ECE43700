onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/PROG/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -color Gold /system_tb/DUT/CPU/DP0/rif/mem_wb_out.pc
add wave -noupdate -color Gold /system_tb/DUT/CPU/DP0/cpu_tracker_opcode
add wave -noupdate -color Gold /system_tb/DUT/CPU/DP0/rif/mem_wb_out.imemload
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate {/system_tb/DUT/CPU/DP0/rf/reg_curr[8]}
add wave -noupdate /system_tb/DUT/CPU/DP0/rif/ex_mem_out.pcsrc
add wave -noupdate /system_tb/DUT/CPU/DP0/rif/ex_mem_out.zero
add wave -noupdate /system_tb/DUT/CPU/DP0/rif/ex_mem_out.rdat1
add wave -noupdate /system_tb/DUT/CPU/DP0/rif/ex_mem_out.rdat2
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP0/sc_flush
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/DCACHE/link_reg
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/DCACHE/link_addr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -expand -group DP0 -color {Cornflower Blue} /system_tb/DUT/CPU/DP0/rif/ex_mem_out.pc
add wave -noupdate -expand -group DP0 -color {Cornflower Blue} /system_tb/DUT/CPU/DP0/mem_opcode
add wave -noupdate -expand -group DP0 -color {Cornflower Blue} /system_tb/DUT/CPU/DP0/rif/ex_mem_out.imemload
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/rif/ex_mem_out.npc
add wave -noupdate -expand -group DP0 -color Violet /system_tb/DUT/CPU/CM0/DCACHE/ds
add wave -noupdate -expand -group DP0 -expand {/system_tb/DUT/CPU/CM0/DCACHE/set[3]}
add wave -noupdate -group DC0 /system_tb/DUT/CPU/DP0/rif/ex_mem_out.regsrc
add wave -noupdate -group DC0 /system_tb/DUT/CPU/DP0/rif/ex_mem_out.regtbw
add wave -noupdate -group DC0 /system_tb/DUT/CPU/DP0/rif/mem_wb_out.regtbw
add wave -noupdate -group DC0 /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate -group DC0 -radix binary {/system_tb/DUT/CPU/ccif/dWEN[0]}
add wave -noupdate -group DC0 -radix binary {/system_tb/DUT/CPU/ccif/dwait[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/CC/daddr[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/CC/dstore[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/dload[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/ccinv[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/ccwrite[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/cctrans[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/ccwait[0]}
add wave -noupdate -group DC0 {/system_tb/DUT/CPU/ccif/ccsnoopaddr[0]}
add wave -noupdate -group DC0 -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/set[1]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/set
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/CM1/DCACHE/link_reg
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/CM1/DCACHE/link_addr
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate -expand -group DP1 -color {Cornflower Blue} /system_tb/DUT/CPU/DP1/mem_opcode
add wave -noupdate -expand -group DP1 -color {Cornflower Blue} /system_tb/DUT/CPU/DP1/rif/ex_mem_out.imemload
add wave -noupdate -expand -group DP1 {/system_tb/DUT/CPU/CM1/DCACHE/set[3]}
add wave -noupdate -expand -group DP1 -color Violet /system_tb/DUT/CPU/CM1/DCACHE/ds
add wave -noupdate -group DC1 -radix binary {/system_tb/DUT/CPU/ccif/dWEN[1]}
add wave -noupdate -group DC1 -radix binary {/system_tb/DUT/CPU/ccif/dwait[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/CC/daddr[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/dload[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/CC/dstore[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/ccinv[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/ccwrite[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/cctrans[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/ccwait[1]}
add wave -noupdate -group DC1 {/system_tb/DUT/CPU/ccif/ccsnoopaddr[1]}
add wave -noupdate -group DC1 -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/set[1]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/set
add wave -noupdate -expand -group CC -color Violet /system_tb/DUT/CPU/CC/s
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/prid
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/nxt_prid
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/CPU/ccif/ramstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5199946 ps} 0}
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
WaveRestoreZoom {3943800 ps} {6760800 ps}
