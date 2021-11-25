`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "control_unit_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module control_unit (
    control_unit_if.cu cuif
);
    

    always_comb begin
        // default value of control signals. 
        cuif.regsrc = REGSRC_ALU; 
        cuif.regdst = REGDST_RD; 
        cuif.regWEN = 1'b0; 
        cuif.alusrc = ALUSRC_REG; 
        cuif.extsel = ZERO_EXT;
        cuif.dREN = 1'b0; 
        cuif.dWEN = 1'b0; 
        cuif.aluop = ALU_SLL; 
        cuif.halt = 1'b0; 
        cuif.pcsrc = PCSRC_PC4;
        cuif.datomic = 1'b0; 
        casez (cuif.opcode)
            RTYPE: begin
                cuif.regsrc = REGSRC_ALU; 
                cuif.regdst = REGDST_RD; 
                cuif.regWEN = 1'b1;
                cuif.alusrc = ALUSRC_REG; 
                casez (cuif.funct)
                    SLLV:       cuif.aluop = ALU_SLL; 
                    SRLV:       cuif.aluop = ALU_SRL; 
                    ADD, ADDU:  cuif.aluop = ALU_ADD; 
                    SUB, SUBU:  cuif.aluop = ALU_SUB;
                    AND:        cuif.aluop = ALU_AND; 
                    OR:         cuif.aluop = ALU_OR; 
                    XOR:        cuif.aluop = ALU_XOR; 
                    NOR:        cuif.aluop = ALU_NOR; 
                    SLT:        cuif.aluop = ALU_SLT; 
                    SLTU:       cuif.aluop = ALU_SLTU; 
                    JR: begin
                        cuif.regWEN = 1'b0; 
                        cuif.pcsrc =  PCSRC_REG; 
                    end
                    default:    cuif.aluop = ALU_SLL; 
                endcase
            end
            BEQ: begin
                cuif.extsel = SIGN_EXT; 
                cuif.aluop = ALU_SUB; 
                cuif.pcsrc = PCSRC_BEQ; 
            end
            BNE: begin
                cuif.extsel = SIGN_EXT; 
                cuif.aluop = ALU_SUB; 
                cuif.pcsrc = PCSRC_BNE;  

            end
            ADDI, ADDIU: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1;
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.aluop = ALU_ADD; 
            end 
            SLTI: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.aluop = ALU_SLT; 
            end  
            SLTIU: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.aluop = ALU_SLTU; 
            end
            ANDI: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.aluop = ALU_AND; 
            end
            ORI: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.aluop = ALU_OR; 
            end
            XORI: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.aluop = ALU_XOR; 
            end 
            LUI: begin
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; 
                cuif.regsrc = REGSRC_LUI; 
            end
            LW: begin
                cuif.regsrc = REGSRC_MEM; 
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; // dhit 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.dREN = 1'b1;   // ihit 
                cuif.aluop = ALU_ADD; 
            end
            SW: begin
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.dWEN = 1'b1; 
                cuif.aluop = ALU_ADD; 
            end
            //J: begin // no changes necessary
            //end
            JAL: begin
                cuif.regsrc = REGSRC_NPC; 
                cuif.regdst = REGDST_RA; 
                cuif.regWEN = 1'b1; 
                cuif.pcsrc = PCSRC_JAL; 
            end
            J: begin
                cuif.pcsrc = PCSRC_JAL; 
            end
            LL: begin
                cuif.regsrc = REGSRC_MEM; 
                cuif.regdst = REGDST_RT; 
                cuif.regWEN = 1'b1; // dhit 
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.dREN = 1'b1;   // ihit 
                cuif.aluop = ALU_ADD; 
                cuif.datomic = 1'b1; 
            end
            SC: begin
                cuif.alusrc = ALUSRC_IMM; 
                cuif.extsel = SIGN_EXT;
                cuif.dWEN = 1'b1; 
                cuif.aluop = ALU_ADD; 
                cuif.datomic = 1'b1; 
            end
            HALT: begin
                cuif.halt = 1'b1; 
            end
            default: begin
                cuif.pcsrc = PCSRC_PC4; 
                cuif.regsrc = REGSRC_ALU; 
                cuif.regdst = REGDST_RD; 
                cuif.regWEN = 1'b0; 
                cuif.alusrc = ALUSRC_REG; 
                cuif.extsel = ZERO_EXT;
                cuif.dREN = 1'b0; 
                cuif.dWEN = 1'b0; 
                cuif.aluop = ALU_SLL; 
            end
        endcase
    end
endmodule
