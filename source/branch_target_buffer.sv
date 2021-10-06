`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "branch_target_buffer_if.vh"

module name (
    input logic CLK, nRST, 
    branch_target_buffer_if btbif
);

    branch_pred_frame_t [255:0] buffer; 
    branch_pred_frame_t next_entry; 
    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            buffer <= '{BPRED_NS, word_t'(0)}
        end
        else begin 
            buffer[btbif.wsel.ind] <= next_entry; 
        end 
    end

    always_comb begin
        next_entry = {BPRED_NS, word_t'(0)}; 
        if (btbif.wen) begin
            next_entry = wdat; 
        end
        else begin
            next_entry = buffer[btbif.wsel.ind]; 
        end
    end
    
endmodule