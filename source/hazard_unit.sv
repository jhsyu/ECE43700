`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*; 

module hazard_unit (
    hazard_unit_if.hu huif
);
    logic phit; // indicating if the prediction is correct. 
    always_comb begin
        phit = 1'b1; 
        huif.if_id_en = huif.dhit | huif.ihit; 
        huif.id_ex_en = huif.dhit | huif.ihit; 
        huif.ex_mem_en = huif.dhit | huif.ihit; 
        huif.mem_wb_en = huif.dhit | huif.ihit; 
        huif.if_id_flush = 1'b0; 
        huif.id_ex_flush = 1'b0; 
        huif.ex_mem_flush = 1'b0; 
        huif.mem_wb_flush = 1'b0; 
        huif.pcen = 1'b1; 
        // deal with data hazard. 
        if (huif.ex_regWEN && huif.ex_rd != regbits_t'(0) &&
           (huif.ex_rd == huif.id_rs || huif.ex_rd == huif.id_rt)) begin
            huif.if_id_flush = 1'b1;    // flush if/id. insert nop here.
            huif.pcen = 1'b0;        // stall the increment of pcen. 
        end
        else if (huif.mem_regWEN && huif.mem_rd != regbits_t'(0) &&
                (huif.mem_rd == huif.id_rs || huif.mem_rd == huif.id_rt)) begin
            huif.if_id_flush = 1'b1;    // flush if/id. insert nop here.
            huif.pcen = 1'b0;        // stall the increment of pcen. 
        end
        // deal with branch mis-predictions.
        casez(huif.mem_pcsrc) 
            PCSRC_BEQ: phit = (huif.zero) ? 1'b1 : 1'b0; 
            PCSRC_BNE: phit = (huif.zero) ? 1'b0 : 1'b1;
            PCSRC_JAL: phit = 1'b0; 
            PCSRC_REG: phit = 1'b0; 
            default: phit = 1'b1;
        endcase

        if (~phit) begin    // misprediction
            huif.pcen = 1'b1;
            huif.if_id_flush = 1'b1; 
            huif.id_ex_flush = 1'b1; 
        end
        if (huif.halt) begin
            huif.pcen = 1'b0; 
        end
    end
endmodule