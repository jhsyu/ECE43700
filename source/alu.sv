`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu (
    alu_if.alu aluif
); 
    import cpu_types_pkg::*; 
    always_comb begin
        aluif.port_o = word_t'(0);
        aluif.n = 1'b0; 
        aluif.z = 1'b1; 
        aluif.v = 1'b0; 
        casez (aluop)
            ALU_SLL:    // left logical shift.   
            ALU_SRL:    // right logical shift. 
            ALU_ADD:    // alu add. 
            ALU_SUB:    // alu sub
            ALU_AND:    // alu and. 
            ALU_OR:     // alu or. 
            ALU_XOR:    // exclusive or. 
            ALU_NOR:    // not or
            ALU_SLT:    // set if less than signed. 
            ALU_SLTU:   // set if less than unsigned. 
        endcase
    end

endmodule