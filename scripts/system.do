onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/nRST
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -group ccif -radix binary /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group ccif -radix binary /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group ccif -radix binary /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group ccif -radix binary /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group ccif -radix binary /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group ccif -expand /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group ccif {/system_tb/DUT/CPU/ccif/iaddr[1]}
add wave -noupdate -group ccif {/system_tb/DUT/CPU/ccif/iaddr[0]}
add wave -noupdate -group ccif -expand /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group ccif -expand /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -group ram /system_tb/DUT/prif/ramREN
add wave -noupdate -group ram /system_tb/DUT/prif/ramaddr
add wave -noupdate -group ram /system_tb/DUT/prif/ramload
add wave -noupdate -group ram /system_tb/DUT/prif/ramWEN
add wave -noupdate -group ram /system_tb/DUT/prif/ramstore
add wave -noupdate -group ram /system_tb/DUT/prif/ramstate
add wave -noupdate -group ram /system_tb/DUT/prif/memREN
add wave -noupdate -group ram /system_tb/DUT/prif/memWEN
add wave -noupdate -group ram /system_tb/DUT/prif/memaddr
add wave -noupdate -group ram /system_tb/DUT/prif/memstore
add wave -noupdate -group cc /system_tb/DUT/CPU/CC/s
add wave -noupdate -group cc /system_tb/DUT/CPU/CC/nxt_s
add wave -noupdate -group cc /system_tb/DUT/CPU/CC/prid
add wave -noupdate -group cc /system_tb/DUT/CPU/CC/nxt_prid
add wave -noupdate -group cc /system_tb/DUT/CPU/CC/iaddr
add wave -noupdate -group dp0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group dp0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group dp0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group dp0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group dp0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group dp1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dp1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dp1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dp1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dp1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group ic0 /system_tb/DUT/CPU/CM0/ICACHE/s
add wave -noupdate -group ic0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group ic0 -radix binary {/system_tb/DUT/CPU/ccif/iwait[0]}
add wave -noupdate -group ic0 {/system_tb/DUT/CPU/ccif/iaddr[0]}
add wave -noupdate -group ic0 {/system_tb/DUT/CPU/ccif/iload[0]}
add wave -noupdate -group ic1 /system_tb/DUT/CPU/CM1/ICACHE/s
add wave -noupdate -group ic1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group ic1 {/system_tb/DUT/CPU/ccif/iaddr[1]}
add wave -noupdate -group ic1 {/system_tb/DUT/CPU/ccif/iload[1]}
add wave -noupdate -group ic1 -radix binary {/system_tb/DUT/CPU/ccif/iwait[1]}
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate {/system_tb/DUT/CPU/ccif/cctrans[1]}
add wave -noupdate {/system_tb/DUT/CPU/ccif/cctrans[0]}
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/CM0/DCACHE/snp_hit
add wave -noupdate -expand -group dc0 -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/set[6]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/set[0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/set
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate -expand -group dc0 -expand /system_tb/DUT/CPU/CM0/DCACHE/snp_hit_frame
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/CM0/cif/dWEN
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -expand -group dc0 /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -expand -group dc0 -color {Violet Red} /system_tb/DUT/CPU/CM0/DCACHE/ds
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/dload
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/dwait
add wave -noupdate -expand -group dc1 -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/set[0]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/set
add wave -noupdate -expand -group dc1 -color {Violet Red} /system_tb/DUT/CPU/CM1/DCACHE/ds
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/dhit
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -expand -group dc1 /system_tb/CLK
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccinv
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/cif/ccwait
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/snpaddr
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/snp_hit_frame_idx
add wave -noupdate -expand -group dc1 -expand /system_tb/DUT/CPU/CM1/DCACHE/snp_hit_frame
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/CM1/DCACHE/snp_hit
add wave -noupdate -expand -group dc1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/dload
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/cif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/prif/ramREN
add wave -noupdate /system_tb/DUT/prif/ramaddr
add wave -noupdate /system_tb/DUT/prif/ramload
add wave -noupdate /system_tb/DUT/prif/ramstate
add wave -noupdate -color {Medium Orchid} /system_tb/DUT/CPU/CC/s
add wave -noupdate /system_tb/DUT/CPU/CC/prid
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -expand -group DP0 -color Cyan /system_tb/DUT/CPU/DP0/mem_opcode
add wave -noupdate -expand -group DP0 -color Cyan /system_tb/DUT/CPU/DP0/rif/ex_mem_out.imemload
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group DP1 -color Cyan /system_tb/DUT/CPU/DP1/mem_opcode
add wave -noupdate -expand -group DP1 -color Cyan /system_tb/DUT/CPU/DP1/rif/ex_mem_out.imemload
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/CM1/dcif/dmemstore
add wave -noupdate -radix binary -childformat {{{/system_tb/DUT/CPU/ccif/dWEN[1]} -radix binary} {{/system_tb/DUT/CPU/ccif/dWEN[0]} -radix binary}} -expand -subitemconfig {{/system_tb/DUT/CPU/ccif/dWEN[1]} {-height 16 -radix binary} {/system_tb/DUT/CPU/ccif/dWEN[0]} {-height 16 -radix binary}} /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -radix binary -childformat {{{/system_tb/DUT/CPU/ccif/dwait[1]} -radix binary} {{/system_tb/DUT/CPU/ccif/dwait[0]} -radix binary}} -expand -subitemconfig {{/system_tb/DUT/CPU/ccif/dwait[1]} {-height 16 -radix binary} {/system_tb/DUT/CPU/ccif/dwait[0]} {-height 16 -radix binary}} /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -expand /system_tb/DUT/CPU/CC/daddr
add wave -noupdate -expand /system_tb/DUT/CPU/CC/dstore
add wave -noupdate /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate /system_tb/DUT/CPU/CC/nxt_prid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3625890 ps} 0}
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
WaveRestoreZoom {3326 ns} {4010 ns}
