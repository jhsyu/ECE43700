onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group PC /system_tb/DUT/CPU/DP/pcen
add wave -noupdate -group PC /system_tb/DUT/CPU/DP/cuif/pcsrc
add wave -noupdate -group PC /system_tb/DUT/CPU/DP/cpc
add wave -noupdate -group PC /system_tb/DUT/CPU/DP/npc
add wave -noupdate -group PC /system_tb/DUT/CPU/DP/pc4
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -group CU -radix binary /system_tb/DUT/CPU/DP/cuif/funct
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/regsrc
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/regdst
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/extsel
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/regWEN
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/alusrc
add wave -noupdate -group CU /system_tb/DUT/CPU/DP/cuif/aluop
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM -radix hexadecimal /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -group datapath /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/aluop
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/port_o
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/n
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/z
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/v
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group ALU /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rf/reg_curr
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/if_id_in
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/if_id_out
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/id_ex_in
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/id_ex_out
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/ex_mem_in
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/ex_mem_out
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/mem_wb_in
add wave -noupdate -expand -group pipeline /system_tb/DUT/CPU/DP/mem_wb_out
add wave -noupdate {/system_tb/DUT/CPU/DP/rf/reg_curr[10]}
add wave -noupdate -label regsrc /system_tb/DUT/CPU/DP/mem_wb_out.regsrc
add wave -noupdate -label rdat1 /system_tb/DUT/CPU/DP/id_ex_in.rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/port_o
add wave -noupdate -label alusrc /system_tb/DUT/CPU/DP/id_ex_out.alusrc
add wave -noupdate -label imemload /system_tb/DUT/CPU/DP/id_ex_out.imemload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {223083 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
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
WaveRestoreZoom {91288 ps} {319535 ps}
