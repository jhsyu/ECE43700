`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu (alu_if.alu aluif); 
    import cpu_types_pkg::*;
    always_comb begin
        aluif.port_o = word_t'(0);
        aluif.v = 1'b0; 
        casez (aluif.aluop)
            ALU_SLL:        // left logical shift. 
                aluif.port_o = aluif.port_b << aluif.port_a[4:0];                  
            ALU_SRL:        // right logical shift. 
                aluif.port_o = aluif.port_b >> aluif.port_a[4:0]; 
            ALU_ADD: begin  // alu add. 
                aluif.port_o = $signed(aluif.port_a) + $signed(aluif.port_b); 
                aluif.v = (aluif.port_a[31] == aluif.port_b[31]) && (aluif.port_o[31] != aluif.port_a[31]); 
                /* ADD overflow detection:
                    case 1: 
                        Both A and B are postive (~A[31] && ~B[31]), but result is negative (O[31])
                    case 2: 
                        Both A and B are negative (A[31] && B[31]), but the result is postive (~O[31]). 
                */
            end
            ALU_SUB: begin  // alu sub. 
                aluif.port_o = $signed(aluif.port_a) - $signed(aluif.port_b);
                aluif.v = (aluif.port_a[31] != aluif.port_b[31]) && (aluif.port_o[31] != aluif.port_a[31]); 
                /* SUB overflow detection:
                    case 1: 
                        Both A and -B are postive (~A[31] && B[31]), but result is negative (O[31])
                    case 2: 
                        Both A and -B are negative (A[31] && ~B[31]), but the result is postive (~O[31]). 
                */
            end
            ALU_AND:        // alu and. 
                aluif.port_o = aluif.port_a & aluif.port_b; 
            ALU_OR:         // alu or. 
                aluif.port_o = aluif.port_a | aluif.port_b; 
            ALU_XOR:        // exclusive or. 
                aluif.port_o = aluif.port_a ^ aluif.port_b; 
            ALU_NOR:        // not or
                aluif.port_o = ~(aluif.port_a | aluif.port_b); 
            ALU_SLT:        // set if less than signed. 
                aluif.port_o = ($signed(aluif.port_a) < $signed(aluif.port_b)) ? word_t'(1) : word_t'(0); 
            ALU_SLTU:       // set if less than unsigned. 
                aluif.port_o = ($unsigned(aluif.port_a) < $unsigned(aluif.port_b))? word_t'(1) : word_t'(0); 
        endcase
    end

    assign aluif.n = aluif.port_o[31]; 
    assign aluif.z = ~(|aluif.port_o);

endmodule