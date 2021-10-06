`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "forwarding_if.vh"
`timescale 1ns/1ns

import cpu_types_pkg::*; 
import dp_types_pkg::*; 

module forwarding_tb;

    forwarding_if fwif(); 
    forwarding DUT(fwif);
    test PROG(fwif); 
endmodule

program test (
    forwarding_if.tb fwif
); 
    int test_case_num = 0; 
    initial begin
        // initialization
        fwif.rs = regbits_t'(1); 
        fwif.rt = regbits_t'(2); 
        fwif.ex_mem_regtbw = regbits_t'(3);
        fwif.mem_wb_regtbw = regbits_t'(4); 
        fwif.ex_mem_regWEN = 1'b0; 
        fwif.mem_wb_regWEN = 1'b0; 
        #(20);  
        test_case_num ++; 
        // test 1: ID/EX.rs == EX/MEM.rd
        fwif.rs = regbits_t'(15); 
        fwif.ex_mem_regtbw = regbits_t'(15); 
        #(20); 
        fwif.ex_mem_regWEN = 1'b1; 
        #(20); 
        fwif.ex_mem_regWEN = 1'b0; 
        fwif.rs = regbits_t'(1); 
        fwif.ex_mem_regtbw = regbits_t'(3); 
        test_case_num ++; 
        // test 2: ID/EX.rt == EX/MEM.rd
        fwif.rt = regbits_t'(15); 
        fwif.ex_mem_regtbw = regbits_t'(15); 
        #(20); 
        fwif.ex_mem_regWEN = 1'b1; 
        #(20); 
        fwif.ex_mem_regWEN = 1'b0; 
        fwif.rt = regbits_t'(2); 
        fwif.ex_mem_regtbw = regbits_t'(3); 
        test_case_num ++; 
        // test 3: ID/EX.rs == MEM/WB.rd
        fwif.rs = regbits_t'(15); 
        fwif.mem_wb_regtbw = regbits_t'(15); 
        #(20); 
        fwif.mem_wb_regWEN = 1'b1; 
        #(20); 
        fwif.mem_wb_regWEN = 1'b0; 
        fwif.rs = regbits_t'(1); 
        fwif.mem_wb_regtbw = regbits_t'(4); 
        test_case_num ++; 
        // test 4: ID/EX.rt == MEM/WB.rd
        fwif.rt = regbits_t'(15); 
        fwif.mem_wb_regtbw = regbits_t'(15); 
        #(20); 
        fwif.mem_wb_regWEN = 1'b1; 
        #(20); 
        fwif.mem_wb_regWEN = 1'b0; 
        fwif.rt = regbits_t'(2); 
        fwif.mem_wb_regtbw = regbits_t'(4); 

    end
endprogram