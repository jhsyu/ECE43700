onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/cuif/pcsrc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/cpc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/npc
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/pc4
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/huif/pcen
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -expand -group CU -radix binary /system_tb/DUT/CPU/DP/cuif/funct
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/pcsrc
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regsrc
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regdst
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/extsel
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/regWEN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/alusrc
add wave -noupdate -expand -group CU /system_tb/DUT/CPU/DP/cuif/aluop
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM -radix hexadecimal /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstate
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
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rf/reg_curr
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group RegFile -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/hu/phit
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/halt
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/ex_regWEN
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/mem_regWEN
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/id_rs
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/id_rt
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/ex_rd
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/mem_rd
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/zero
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/mem_pcsrc
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/if_id_en
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/id_ex_en
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/ex_mem_en
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/mem_wb_en
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/if_id_flush
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/id_ex_flush
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/ex_mem_flush
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/mem_wb_flush
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/pcen
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/rif/if_id_in.pc
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/npc
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/rif/if_id_in.imemload
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.pcsrc
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.pc
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.imemload
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.rt
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.rd
add wave -noupdate -expand -group ID /system_tb/DUT/CPU/DP/rif/id_ex_in.imm32
add wave -noupdate -expand -group ID -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group ID -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/id_ex_out.pc
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/id_ex_out.imemload
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/id_ex_out.pcsrc
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/id_ex_out.rd
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/id_ex_out.rt
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/ex_mem_in.regtbw
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/ex_mem_in.zero
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/rif/ex_mem_in.regWEN
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/ex_mem_out.pcsrc
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/npc
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/mem_wb_out.baddr
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/ex_mem_out.regtbw
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/ex_mem_out.regWEN
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/ex_mem_out.jaddr
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/mem_wb_in.npc
add wave -noupdate -expand -group MEM /system_tb/DUT/CPU/DP/rif/ex_mem_out.imemload
add wave -noupdate -expand -group WB /system_tb/DUT/CPU/DP/rif/mem_wb_out.pc
add wave -noupdate -expand -group WB /system_tb/DUT/CPU/DP/rif/mem_wb_out.imemload
add wave -noupdate -expand -group WB /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group WB -radix unsigned /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group WB /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group WB /system_tb/DUT/CPU/DP/rf/reg_curr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {381036 ps} 0}
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
WaveRestoreZoom {0 ps} {597 ns}
