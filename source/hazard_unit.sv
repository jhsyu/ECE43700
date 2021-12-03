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
        huif.if_id_en = 1'b1; 
        huif.id_ex_en = 1'b1; 
        huif.ex_mem_en = 1'b1; 
        huif.mem_wb_en = 1'b1; 
        huif.if_id_flush = 1'b0; 
        huif.id_ex_flush = 1'b0; 
        huif.ex_mem_flush = 1'b0; 
        huif.mem_wb_flush = 1'b0; 
        huif.pcen = 1'b1; 
        // deal with ld-use hazard. 
        if (huif.dmemREN && huif.ex_regWEN && (|huif.ex_rd)) begin
            if (huif.ex_rd == huif.id_rt || huif.ex_rd == huif.id_rs) begin
                huif.id_ex_flush = 1'b1; 
                huif.if_id_en = 1'b0; 
                huif.pcen = 1'b0;        // stall the increment of pcen. 
            end            
        end
        else if (huif.dmemWEN && huif.datomic && (|huif.ex_rd)) begin
            if (huif.ex_rd == huif.id_rt || huif.ex_rd == huif.id_rs) begin
                huif.id_ex_flush = 1'b1; 
                huif.if_id_en = 1'b0; 
                huif.pcen = 1'b0; 
            end
        end
        // deal with branch mis-predictions.
        casez(huif.mem_pcsrc) 
            PCSRC_BEQ: phit = (huif.zero) ? 1'b0 : 1'b1; 
            PCSRC_BNE: phit = (huif.zero) ? 1'b1 : 1'b0;
            PCSRC_JAL: phit = 1'b0; 
            PCSRC_REG: phit = 1'b0; 
            default: phit = 1'b1;
        endcase

        if (~phit) begin    // misprediction
            huif.if_id_en = 1'b1; 
            huif.pcen = 1'b1;
            huif.if_id_flush = 1'b1; 
            huif.id_ex_flush = 1'b1; 
            huif.ex_mem_flush = 1'b1; 
        end
        if (huif.halt) begin
            huif.pcen = 1'b0; 
            huif.if_id_flush = 1'b1;
            huif.id_ex_flush = 1'b1; 
            huif.ex_mem_flush = 1'b1; 
            huif.mem_wb_flush = 1'b1;  
        end
    end
endmodule