`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "control_unit_if.vh"
`timescale 1ns/1ns

import cpu_types_pkg::*;
import dp_types_pkg::*;

module control_unit_tb;
    control_unit_if cuif();
    control_unit DUT(cuif); 
    test PROG(cuif); 
endmodule

program test (control_unit_if.tb cuif);
    opcode_t opcode []; 
    funct_t funct []; 
    int test_case_num = 0; 

    initial begin
        opcode = {
            RTYPE, 
            J,     
            JAL,   
            BEQ,   
            BNE,   
            ADDI,  
            ADDIU, 
            SLTI,  
            SLTIU, 
            ANDI,  
            ORI,   
            XORI,  
            LUI,   
            LW,    
            SW,    
            HALT
        };

        funct = {
            SLLV, 
            SRLV, 
            JR, 
            ADD, 
            ADDU, 
            SUB, 
            SUBU, 
            AND, 
            OR, 
            XOR, 
            NOR, 
            SLT, 
            SLTU
        };

        for (int i = 0; i < 16; i++) begin
            if (opcode[i] == RTYPE) begin
                for (int j = 0; j < 13; j++) begin
                    cuif.opcode = opcode[i];
                    cuif.funct = funct[j]; 
                    cuif.ihit = 1'b0; 
                    cuif.dhit = 1'b0; 
                    #20; 
                    cuif.ihit = 1'b1; 
                    #20; 
                    cuif.dhit = 1'b1; 
                    #20; 
                    test_case_num ++; 
                end
            end
            else begin
                cuif.opcode = opcode[i]; 
                cuif.funct = funct_t'(0); 
                cuif.ihit = 1'b0; 
                cuif.dhit = 1'b0; 
                #20; 
                cuif.ihit = 1'b1; 
                #20; 
                cuif.dhit = 1'b1; 
                #20; 
                test_case_num ++; 
            end
        end

    end


endprogram 
