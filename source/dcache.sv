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
    dcache_state_t ds, nds; 
    word_t hit_count; 
    logic hit_frame; 
    logic evict_id; 
    logic [4:0] dump_idx, nxt_dump_idx; // 0:blkoff 1:frame [4:2] set
    assign daddr = dcachef_t'(dcif.dmemaddr); 
    assign evict_id = ~set[daddr.idx].lru_id;
    assign dcif.dmemload = set[daddr.idx].frame[hit_frame].data[daddr.blkoff];
    
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

    // initialization, load from memory, update lru_id. 
    always_ff @(posedge CLK or negedge nRST) begin
        if (~nRST) begin
            set <= '0; 
        end
        else if (dcif.dhit & dcif.dmemWEN) begin
            set[daddr.idx].lru_id = hit_frame; 
            set[daddr.idx].frame[hit_frame].data[daddr.blkoff] <= dcif.dmemstore; 
            set[daddr.idx].frame[hit_frame].dirty <= 1'b1; 
        end
        else if (dcif.dhit & dcif.dmemREN) begin
            // update the lru_id upon a dhit
            set[daddr.idx].lru_id = hit_frame; 
        end
        // load 1st word. 
        else if (ds == ALLOC0 && ~cif.dwait) begin
            // if the current state is ALLOC0, and dload is ready. 
            set[daddr.idx].frame[evict_id].data[0]    <= cif.dload; 
            set[daddr.idx].frame[evict_id].tag        <= daddr.tag;         
        end
        // load second word. 
        else if (ds == ALLOC1 && ~cif.dwait) begin
            // also sets dirty, valid. 
            set[daddr.idx].frame[evict_id].data[1]    <= cif.dload; 
            set[daddr.idx].frame[evict_id].dirty      <= 1'b0; 
            set[daddr.idx].frame[evict_id].valid      <= 1'b1; 
        end
    end
    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            ds          <= IDLE; 
            dump_idx    <= '0; 
        end
        else begin 
            ds          <= nds;
            dump_idx    <= nxt_dump_idx; 
        end
    end
    // next state and output logic. 
    always_comb begin
        dcif.flushed = 1'b0;
        cif.dREN = 1'b0; 
        cif.dWEN = 1'b0; 
        cif.daddr = word_t'(0); 
        cif.dstore = word_t'(0); 
        nxt_dump_idx = dump_idx; 
        nds = ds; 
        casez(ds)
            IDLE: begin
                if(dcif.halt) nds = DUMP; 
                else if ((dcif.dmemREN || dcif.dmemWEN) && ~dcif.dhit) begin
                    nds = (set[daddr.idx].frame[evict_id].dirty) ? WB0 : ALLOC0; 
                end
            end
            ALLOC0: begin
                cif.dREN = 1'b1; 
                cif.daddr = {daddr[31:3], 3'b000}; 
                nds = (cif.dwait) ? ALLOC0 : ALLOC1; 
            end
            ALLOC1: begin
                cif.dREN = 1'b1; 
                cif.daddr = {daddr[31:3], 3'b100}; 
                nds = (cif.dwait) ? ALLOC1 : IDLE; 
            end
            WB0: begin
                cif.dWEN = 1'b1; 
                cif.daddr = {set[daddr.idx].frame[evict_id].tag, daddr.idx, 3'b000}; 
                cif.dstore = set[daddr.idx].frame[evict_id].data[0]; 
                nds = (cif.dwait) ? WB0 : WB1; 
            end
            WB1: begin
                cif.dWEN = 1'b1; 
                cif.daddr = {set[daddr.idx].frame[evict_id].tag, daddr.idx, 3'b100}; 
                cif.dstore = set[daddr.idx].frame[evict_id].data[1]; 
                nds = (cif.dwait) ? WB1 : ALLOC0; 
            end
            DUMP: begin
                cif.dWEN = set[dump_idx[4:2]].frame[dump_idx[1]].valid & set[dump_idx[4:2]].frame[dump_idx[1]].dirty; 
                cif.daddr = {set[dump_idx[4:2]].frame[dump_idx[1]].tag, dump_idx[4:2], dump_idx[0], 2'b0}; 
                cif.dstore = set[dump_idx[4:2]].frame[dump_idx[1]].data[dump_idx[0]];
                nxt_dump_idx = (~cif.dWEN || ~cif.dwait) ? dump_idx + 1 : dump_idx;
	        if (dump_idx == 5'd31) begin
		   if (cif.dWEN) begin
		      if (cif.dwait) begin
			 nds = DUMP;
		      end
		      else begin
			 nds = COUNT;
		      end
		   end
		   else begin
		      nds = COUNT;
		   end
		end
            end
            COUNT: begin
                cif.dWEN = 1'b1; 
                cif.daddr = word_t'('h3100); 
                cif.dstore = hit_count; 
                nds = (cif.dwait) ? COUNT : CLEAN; 
            end
            CLEAN: begin
                dcif.flushed = 1'b1; 
                nds = CLEAN; 
            end
        endcase
    end

    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            hit_count <= '0; 
        end
        else if ((ds == IDLE) && dcif.dhit && (dcif.dmemWEN || dcif.dmemREN)) begin
            hit_count <= hit_count + 1; 
        end
        else if ((ds == ALLOC1) && (~cif.dwait)) begin
            hit_count <= hit_count - 1; 
        end
    end

endmodule
