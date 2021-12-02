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
    dcachef_t daddr, snpaddr; 
    dcache_line_t [7:0] set; 
    dcache_state_t ds, nds; 
    //word_t hit_count, link_reg; 
    logic hit_frame_idx, snp_hit_frame_idx;
    dcache_frame hit_frame, snp_hit_frame;  
    logic evict_id; 
    logic [4:0] dump_idx, nxt_dump_idx; // 0:blkoff 1:frame [4:2] set
    word_t link_reg, link_addr; 
    assign daddr = dcachef_t'(dcif.dmemaddr); 
    assign snpaddr = dcachef_t'(cif.ccsnoopaddr); 
    assign evict_id = ~set[daddr.idx].lru_id;
    //assign dcif.dmemload = set[daddr.idx].frame[hit_frame_idx].data[daddr.blkoff];
    // check the cache frame and assert dhit.
    logic dhit; // raw signal that just determine if the data present in this cache. 
    //assign dcif.dhit = dhit & (dcif.dmemREN | (dcif.dmemWEN & (~dcif.datomic & hit_frame.dirty))); 
    always_comb begin
        if (dcif.dmemREN && dhit) begin
            dcif.dhit = 1'b1;
        end
        else if (dcif.dmemWEN && dhit) begin
            if (dcif.datomic) begin
                dcif.dhit = (link_reg == link_addr) ? hit_frame.dirty : 1'b1; 
            end
            else begin
                dcif.dhit = hit_frame.dirty; 
            end
        end
        else dcif.dhit = 1'b0; 
        if (cif.ccwait || cif.ccinv) begin
            dcif.dhit = 1'b0; 
        end
    end
    // dirty: wait until the content in dcache updated then assert dhit. 
    // the dirty bit will be set only after the invalidation is done. 
    // 3 cases here:
    // I->M: dirty 0->1
    //      need to invalidate possible copies in other cache. 
    // S->M: dirty 0->1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
    //      need to invalidate possible copies in other cache. 
    // M->M: dirty 1->1
    //      since there is no other copies, no need to go inv. 
    always_comb begin
        if (set[daddr.idx].frame[0].valid && 
            set[daddr.idx].frame[0].tag == daddr.tag) begin
            // hit on frame 0. 
            dhit = 1'b1; 
            hit_frame_idx = 1'b0; 
            hit_frame = set[daddr.idx].frame[0]; 
        end 
        else if (
            set[daddr.idx].frame[1].valid && 
            set[daddr.idx].frame[1].tag == daddr.tag)begin
            // hit on frame 1.
            dhit = 1'b1; 
            hit_frame_idx = 1'b1; 
            hit_frame = set[daddr.idx].frame[1]; 
        end
        else begin
            // miss. 
            dhit = 1'b0; 
            hit_frame_idx = 1'b0; 
            hit_frame = '0; 
        end
    end
    logic snp_hit;  // if hit, the snp_hit_frame is always valid. 
    always_comb begin
        if (set[snpaddr.idx].frame[0].valid && 
            set[snpaddr.idx].frame[0].tag == snpaddr.tag) begin
            // snoop hit on frame 0.
            snp_hit = 1'b1;  
            snp_hit_frame_idx = 1'b0; 
            snp_hit_frame = set[snpaddr.idx].frame[0]; 
        end 
        else if (set[snpaddr.idx].frame[1].valid && 
            set[snpaddr.idx].frame[1].tag == snpaddr.tag)begin
            // snoop hit on frame 1.
            snp_hit = 1'b1; 
            snp_hit_frame_idx = 1'b1; 
            snp_hit_frame = set[snpaddr.idx].frame[1]; 
        end
        else begin
            // miss. 
            snp_hit = 1'b0; 
            snp_hit_frame_idx = 1'b0; 
            snp_hit_frame = '0; 
        end
    end

    // link_reg contains the address of data memory access. 
    // link_addr stores the start address of the coresponding frame in cache.
    assign link_addr = {dcif.dmemaddr[31:3], 3'b0}; 
    // initialization, load from memory, update lru_id. 
    // all the content of cacheline will be updated in this combinational block. 
    always_comb begin
        if (dcif.datomic && dcif.dmemWEN) begin
            // sc case. check link register and the dcif.dmemaddr.
            // 0: incoherence.
            dcif.dmemload = (link_reg == link_addr) ? 32'h1 : 32'h0; 
        end
        else begin
            dcif.dmemload = set[daddr.idx].frame[hit_frame_idx].data[daddr.blkoff];
        end
    end

    always_ff @(posedge CLK or negedge nRST) begin
        if (~nRST) begin
            set <= '0; 
            link_reg <= '0; 
        end
        else if ((cif.ccinv | cif.ccwait) & snp_hit) begin
            // invalid the copy of THIS dcache. 
            set[snpaddr.idx].frame[snp_hit_frame_idx].valid <= ~cif.ccinv; 
            // will be moved to other caches (FWD) or write to mem (FWDWB), or get invalidated. 
            set[snpaddr.idx].frame[snp_hit_frame_idx].dirty <= 1'b0; 
            // if invalidated., replace this block in the incomming conflict. 
            // if just wait, keep the current case. 
            set[snpaddr.idx].lru_id <= (cif.ccinv) ?  ~snp_hit_frame_idx : set[snpaddr.idx].lru_id; 
            // invalidation by other cores.
            link_reg <= (link_reg == word_t'({snpaddr[31:3], 3'b0}) && cif.ccinv) ? 32'hBAD1BAD1 : link_reg; 
        end

        else if (dcif.dhit & dcif.dmemWEN) begin
            if (~dcif.datomic || (dcif.datomic && link_reg == link_addr)) begin
                set[daddr.idx].lru_id <= hit_frame_idx; 
                set[daddr.idx].frame[hit_frame_idx].data[daddr.blkoff] <= dcif.dmemstore; 
                set[daddr.idx].frame[hit_frame_idx].dirty <= 1'b1; 
                // SW/SC will invalidate the link register. 
                link_reg <= (link_reg == link_addr && dcif.dhit) ? 32'hBAD2BAD2 : link_reg; 
            end
        end
        else if (dcif.dhit & dcif.dmemREN) begin
            // update the lru_id upon a dhit
            set[daddr.idx].lru_id <= hit_frame_idx; 
            link_reg <= (dcif.datomic) ? word_t'({dcif.dmemaddr[31:3], 3'b0}) : link_reg; 
        end
        // load 1st word. 
        else if (ds == ALLOC0 && ~cif.dwait) begin
            // if the current state is ALLOC0, and dload is ready. 
            set[daddr.idx].frame[evict_id].data[0]    <= cif.dload; 
        end
        // load second word. 
        else if (ds == ALLOC1 && ~cif.dwait) begin
            // also sets dirty, valid. 
            set[daddr.idx].frame[evict_id].data[1]    <= cif.dload; 
            set[daddr.idx].frame[evict_id].tag        <= daddr.tag;         
            set[daddr.idx].frame[evict_id].dirty      <= 1'b0; 
            set[daddr.idx].frame[evict_id].valid      <= 1'b1; 
        end
        else if (ds == WB1 & ~cif.dwait) begin
            set[daddr.idx].frame[evict_id].valid <= 1'b0; 
            set[daddr.idx].frame[evict_id].dirty <= 1'b0; 
        end
        else if (ds == INV & ~cif.ccwait & ~cif.dwait) begin
            // set the dirty bit, assert dcif.dhit
            set[daddr.idx].frame[hit_frame_idx].dirty <= 1'b1; 
        end
        else if (ds == FLUSH0 & ~cif.ccwait & ~cif.dwait) begin
            // invalidate the cache that is already write back. 
            set[dump_idx[4:2]].frame[dump_idx[1]].dirty <= 1'b0; 
            set[dump_idx[4:2]].frame[dump_idx[1]].valid <= 1'b0; 
        end
    end
    logic dumping; 
    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            ds          <= IDLE; 
            dump_idx    <= '0; 
        end
        else begin 
            ds          <= nds;
            if (dumping) begin
                dump_idx    <= nxt_dump_idx; 
            end
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
        cif.ccwrite = 1'b0; 
        cif.cctrans = 1'b0; 
        nds = ds; 
        dumping = 1'b0; 
        casez(ds)
            IDLE: begin
                if(dcif.halt) nds = FLUSH0; 
                else if (cif.ccwait && snp_hit && snp_hit_frame.dirty) begin
                    // if case is FWD, the cpu should be blocked. 
                    // and the data in the cache should be at M. 
                    nds = FWD0; 
                end
                else if (dcif.dmemWEN && ~cif.ccwait && dhit && ~hit_frame.dirty && 
                        (~dcif.datomic || dcif.datomic && link_reg == link_addr)) begin
                    // the case is that once writing to a shared block, 
                    // invalidate other copies in all cache.
                    // this should be happening before the dcif.dhit.
                    // at this time dhit is 1'b1, but dcif.dhit is still waiting for dirty bit to set. 
                    // shared state: valid, ~dirty.
                    nds = INV; 
                end
                else if ((dcif.dmemREN || dcif.dmemWEN) && ~dhit && ~cif.ccwait) begin
                    // ~dhit indicate the incomming request does not appears in the cache. 
                    // check the victim, if dirty, write back, if vacant, just do the allocate.
                    nds = (set[daddr.idx].frame[evict_id].dirty) ? WB0 : ALLOC0; 
                end
            end
            INV: begin
                cif.cctrans = 1'b1; //I/S->M
                cif.ccwrite = dcif.dmemWEN; 
                cif.daddr = {daddr[31:3], 1'b0, 2'b0}; 
                nds = (cif.dwait) ? INV : IDLE; 
            end
            FWD0: begin
                cif.cctrans = 1'b1; 
                cif.dstore = snp_hit_frame.data[0]; 
                cif.daddr = {snpaddr[31:3], 1'b0, 2'b0};
                nds = (cif.dwait) ? FWD0 : FWD1; 
            end
            FWD1: begin
                cif.dstore = snp_hit_frame.data[1]; 
                cif.daddr = {snpaddr[31:3], 1'b1, 2'b0};
                nds = (cif.dwait) ? FWD1 : IDLE; 
            end
            ALLOC0: begin
                cif.cctrans = 1'b1; // i->s, the valid and dirty is set in ALLOC1.
                cif.ccwrite = dcif.dmemWEN; 
                cif.dREN = 1'b1; 
                cif.daddr = {daddr[31:3], 3'b000}; 
                nds = (cif.dwait) ? ALLOC0 : ALLOC1; 
            end
            ALLOC1: begin
                cif.ccwrite = dcif.dmemWEN; 
                cif.dREN = 1'b1; 
                cif.daddr = {daddr[31:3], 3'b100}; 
                nds = (cif.dwait) ? ALLOC1 : IDLE; 
            end
            WB0: begin
                cif.cctrans = 1'b1; // S/M->I. both dirty and valid are updated upon finish of wb. 
                cif.ccwrite = dcif.dmemWEN;  
                cif.dWEN = 1'b1; 
                cif.daddr = {set[daddr.idx].frame[evict_id].tag, daddr.idx, 3'b000}; 
                cif.dstore = set[daddr.idx].frame[evict_id].data[0]; 
                nds = (cif.dwait) ? WB0 : WB1; 
            end
            WB1: begin 
                cif.ccwrite = dcif.dmemWEN; 
                cif.dWEN = 1'b1; 
                cif.daddr = {set[daddr.idx].frame[evict_id].tag, daddr.idx, 3'b100}; 
                cif.dstore = set[daddr.idx].frame[evict_id].data[1]; 
                nds = (cif.dwait) ? WB1 : IDLE; 
            end
            FLUSH0: begin
                if (cif.ccwait & snp_hit & snp_hit_frame.valid & snp_hit_frame.dirty) begin
                    nds = FWD0; 
                end
                else begin
                    dumping = 1'b1; 
                    if (set[dump_idx[4:2]].frame[dump_idx[1]].valid & set[dump_idx[4:2]].frame[dump_idx[1]].dirty) begin
                        cif.cctrans = 1'b1; 
                        cif.dWEN = 1'b1; 
                        cif.daddr = {set[dump_idx[4:2]].frame[dump_idx[1]].tag, dump_idx[4:2], dump_idx[0], 2'b0}; 
                        cif.dstore = set[dump_idx[4:2]].frame[dump_idx[1]].data[dump_idx[0]];
                        nxt_dump_idx = (cif.dwait) ? dump_idx : dump_idx + 1;
                        nds = (cif.dwait) ? FLUSH0 : FLUSH1; 
                    end
                    else begin
                        cif.cctrans = 1'b0; 
                        cif.dWEN = 1'b0; 
                        cif.daddr = '0; 
                        cif.dstore = 'hBAD1BAD1;
                        nxt_dump_idx = dump_idx + 1;
                        nds = (dump_idx < 31) ? FLUSH0 : CLEAN; 
                    end
		        end
                    
            end
            FLUSH1: begin
                dumping = 1'b1; 
                cif.dWEN = 1'b1; 
                cif.daddr = {set[dump_idx[4:2]].frame[dump_idx[1]].tag, dump_idx[4:2], dump_idx[0], 2'b0}; 
                cif.dstore = set[dump_idx[4:2]].frame[dump_idx[1]].data[dump_idx[0]];
                nxt_dump_idx = (cif.dwait) ? dump_idx : dump_idx + 1;
                if (cif.dwait) begin
                    nds = FLUSH1;
                end
                else if (dump_idx < 31) begin
                    nds = FLUSH0; 
                end
                else begin
                    nds = CLEAN; 
                end

            end
            
            //COUNT: begin
            //    cif.cctrans = 1'b1; 
            //    cif.dWEN = 1'b1; 
            //    cif.daddr = word_t'('h3100); 
            //    cif.dstore = hit_count; 
            //    nds = (cif.dwait) ? COUNT : CLEAN; 
            //end
            CLEAN: begin
                dcif.flushed = 1'b1; 
                nds = CLEAN; 
            end
        endcase
    end

endmodule
