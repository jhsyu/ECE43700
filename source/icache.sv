`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_if.vh"
`include "caches_types_pkg.vh"
`include "datapath_cache_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;
import caches_types_pkg::*; 

module icache (
    input logic CLK, input logic nRST,
    datapath_cache_if.icache dcif,
    caches_if.icache cif
);
    icache_frame  [15:0] set; 
    icachef_t iaddr; 
    icache_state_t s; 
    assign iaddr = dcif.imemaddr; 
  
    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            s <= IC_IDLE; 
            set <= '{default: '0};
        end
        else begin
            casez(s)
                IC_IDLE: begin
                    if (~(dcif.imemREN && set[iaddr.idx].valid && (set[iaddr.idx].tag == iaddr.tag))) begin
                        s <= IC_MISS; 
                    end
                    else begin
                        s <= IC_IDLE; 
                    end
                end
                IC_MISS:  begin
                    if (~cif.iwait) begin
                        s <= IC_IDLE; 
                        set[iaddr.idx].valid <= 1'b1; 
                        set[iaddr.idx].tag <= iaddr.tag; 
                        set[iaddr.idx].data <= cif.iload; 
                    end
                    else begin 
                        s <= IC_MISS;
                    end 
                end
            endcase
        end
    end
  assign dcif.ihit = dcif.imemREN && set[iaddr.idx].valid && (set[iaddr.idx].tag == iaddr.tag);  
  assign dcif.imemload = set[iaddr.idx].data; // 
  assign cif.iaddr = dcif.imemaddr; 
  assign cif.iREN = (s == IC_MISS) ? 1'b1 : 1'b0; 
endmodule
