`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "branch_predictor_if.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*; 

module branch_predictor(
    input logic CLK, nRST, 
    branch_predictor_if bpif
);
    // design concept: latch the cpc as cpc_l, compare it with pc4 and baddr.
    //   
    branch_pred_state_t s, nxt_s; 
    always_ff @(posedge CLK, negedge nRST) begin
         if (~nRST) begin
            s <= BPRED_NS;
	 end
         // adding else condition for updating the state
         else begin
	    s <= nxt_s;
	 end
    end
    always_comb begin
        casez(s)
            BPRED_NH: begin
                nxt_s = (bpif.phit) ? BPRED_NS : BPRED_NH; 
            end
            BPRED_NS: begin
                //nxt_s = (bpif.phit) ? BPRED_TH : BPRED_NH;
	            nxt_s = (bpif.phit) ? BPRED_TS : BPRED_NH;
            end
            BPRED_TH: begin
                nxt_s = (bpif.phit) ? BPRED_TH : BPRED_TS; 
            end
            BPRED_TS:begin
                //nxt_s = (bpif.phit) ? BPRED_TH : BPRED_NH;
	            nxt_s = (bpif.phit) ? BPRED_TH : BPRED_NS;
	        end
            default: begin
                nxt_s = BPRED_NH;
	        end
        endcase
        if (bpif.loadEN) begin
            nxt_s = bpif.buf_load;  
        end
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