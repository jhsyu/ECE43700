onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/clk
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/DUT/daddr
add wave -noupdate /dcache_tb/DUT/set
add wave -noupdate /dcache_tb/DUT/ds
add wave -noupdate /dcache_tb/DUT/nds
add wave -noupdate /dcache_tb/DUT/hit_count
add wave -noupdate /dcache_tb/DUT/hit_frame
add wave -noupdate /dcache_tb/DUT/evict_id
add wave -noupdate /dcache_tb/DUT/dump_idx
add wave -noupdate -radix unsigned /dcache_tb/DUT/nxt_dump_idx
add wave -noupdate /dcache_tb/DUT/dcif/dhit
add wave -noupdate -expand -group RAM /dcache_tb/DUT/cif/dload
add wave -noupdate -expand -group RAM /dcache_tb/DUT/cif/dstore
add wave -noupdate -expand -group RAM /dcache_tb/DUT/cif/daddr
add wave -noupdate -expand -group RAM /dcache_tb/DUT/cif/dWEN
add wave -noupdate -expand -group RAM /dcache_tb/DUT/cif/dREN
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/dmemREN
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/dmemWEN
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/dmemload
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/dmemstore
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/dmemaddr
add wave -noupdate -expand -group Datapath /dcache_tb/DUT/dcif/flushed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {315 ns} 0}
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
WaveRestoreZoom {0 ns} {494 ns}
