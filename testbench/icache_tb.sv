`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;
import dp_types_pkg::*;

module icache_tb;
    parameter PERIOD = 10; 
    logic CLK = 0, nRST; 
    always #(PERIOD/2) CLK++;
    caches_if cif0();
    datapath_cache_if icif(); 
    icache DUT(CLK, nRST, icif.icache, cif0.icache); 
    test PROG(CLK, nRST, icif.icache, cif0.icache); 
endmodule

program test (
  input logic CLK, output logic nRST,
  datapath_cache_if.icache icif,
  caches_if.icache cif
);
    string test_case; 
    int test_case_num = 0; 

    initial begin
        test_case = "Initial Setup"; 
        icif.imemaddr = '0; 
        icif.imemREN = 1'b0; 
        cif.iload = '0; 
        cif.iwait = 1'b1; 
        nRST = 1'b0;
        @(posedge CLK); 
        @(negedge CLK); 
        nRST = 1'b1;
        icif.imemREN = 1'b1;
        test_case_num++; 
        test_case = "1st Compulsory Miss"; 
        icif.imemaddr = 32'h00CD12A4; 
        cif.iload = 32'hABCD1234; 
        repeat(2)@(posedge CLK); 
        cif.iwait = 1'b0; 
        @(posedge CLK); 
        cif.iwait = 1'b1; 
        repeat(3)@(posedge CLK);
        @(posedge CLK); 
        @(negedge CLK);
        test_case_num++; 
        test_case = "Conflict Miss"; 
        icif.imemaddr = 32'h00DC12A4; 
        cif.iload = 32'h1234ABCD; 
        repeat(2)@(posedge CLK); 
        cif.iwait = 1'b0; 
        @(posedge CLK); 
        cif.iwait = 1'b1; 
        repeat(3)@(posedge CLK);
        @(posedge CLK); 
        @(negedge CLK);
        test_case_num++; 
        test_case = "2nd Compulsory Miss"; 
        icif.imemaddr = 32'h00EF3121; 
        cif.iload = 32'h00FF00FF; 
        repeat(4)@(posedge CLK); 
        cif.iwait = 1'b0; 
        @(posedge CLK); 
        cif.iwait = 1'b1; 
        repeat(3)@(posedge CLK);
        @(posedge CLK); 
        @(negedge CLK);
        test_case_num++; 
        test_case = "Instruction Hit"; 
        icif.imemaddr = 32'h00DC12A4; 
        cif.iload = '0;
        repeat(4)@(posedge CLK); 

    end


endprogram 
