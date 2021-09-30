`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "branch_pred_if.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*; 

module branch_pred(
    input logic CLK, nRST, 
    branch_pred_if bpif
);
    // design concept: latch the cpc as cpc_l, compare it with pc4 and baddr.
    //   
    bpred_t s, nxt_s; 
    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            s <= BPRED_NH
        end
    end
    always_comb begin
        casez(s)
        BPRED_NH: begin
            nxt_s = (bpif.phit) ? BPRED_NS : BPRED_NH; 
        end
        BPRED_NS: begin
            nxt_s = (bpif.phit) ? BPRED_TH : BPRED_NH; 
        end
        BPRED_TH: begin
            nxt_s = (bpif.phit) ? BPRED_TH : BPRED_TS; 
        end
        BPRED_TS:begin
            nxt_s = (bpif.phit) ? BPRED_TH : BPRED_NH; 
        default: begin
            nxt_s = BPRED_NH; 
        endcase
    end

    always_comb begin
        casez(s)
        BPRED_NH, BPRED_NS: begin
            bpif.npc = bpif.pc4; 
        end
        BPRED_TH, BPRED_TS: begin
            bpif.npc = bpif.baddr;
        end
        default: begin
            bpif.npc = bpif.pc4; 
        end
        endcase 
    end
endmodule
