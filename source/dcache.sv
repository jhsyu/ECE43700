`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*;
import caches_types_pkg::*; 


module dcache(
    input logic CLK, nRST, 
    datapath_cache_if.dcache dcif,
    caches_if.dcache cif 
);
    dcachef_t daddr; 
    dcache_line_t [7:0] set; 
    logic hit_frame; 
    assign daddr = dcachef_t'(dcif.dmemaddr);
    // check the cache frame and assert dhit.
    always_comb begin
        if (set[daddr.idx].frame[0].valid && 
            set[daddr.idx].frame[0].tag == daddr.tag) begin
            // hit on frame 0. 
            dcif.dhit = 1'b1; 
            hit_frame = 1'b0; 
        end 
        else if (
            set[daddr.idx].frame[1].valid && 
            set[daddr.idx].frame[1].tag == daddr.tag)begin
            // hit on frame 1.
            dcif.dhit = 1'b1; 
            hit_frame = 1'b1; 

        end
        else begin
            // miss. 
            dcif.dhit = 1'b0; 
            hit_frame = 1'b0; 
        end
    end

    
    
endmodule