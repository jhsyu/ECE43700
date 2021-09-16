onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/cuif/pcsrc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/cpc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/npc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/pc4
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/jaddr
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/baddr
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/ihit
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/dhit
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -expand -group CU -radix binary /system_tb/DUT/CPU/DP/cuif/funct
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regsrc
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regdst
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/extsel
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regWEN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/alusrc
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/aluop
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -expand -group datapath /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/aluop
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/port_o
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/n
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/z
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/v
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rf/reg_curr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59570 ps} 0}
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
WaveRestoreZoom {0 ps} {295 ns}
