`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "branch_target_buffer_if.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*;

module branch_target_buffer (
    input logic CLK, nRST, 
    branch_target_buffer_if btbif
);

    branch_pred_frame_t buffer [255:0]; 
    branch_pred_frame_t next_entry; 
    always_ff @(negedge CLK, negedge nRST) begin
        if (~nRST) begin
            for (int i=0; i<256; i++) begin
                buffer[i] <= {BPRED_NS, word_t'(0)}; 
            end
        end
        else begin 
            buffer[btbif.wsel.ind] <= next_entry; 
        end 
    end

    always_comb begin
        next_entry = {BPRED_NS, word_t'(0)}; 
        if (btbif.wen) begin
            next_entry = btbif.wdat; 
        end
        else begin
            next_entry = buffer[btbif.wsel.ind]; 
        end
    end

    assign btbif.rdat = buffer[btbif.rsel.ind]; 
    
endmodule