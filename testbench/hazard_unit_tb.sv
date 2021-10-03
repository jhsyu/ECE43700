`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "hazard_unit_if.vh"
`timescale 1ns/1ns

import cpu_types_pkg::*;
import dp_types_pkg::*;

parameter PERIOD = 10;

module hazard_unit_tb;
    logic CLK = 0;
    always #(PERIOD/2) CLK++;
    hazard_unit_if huif();
    hazard_unit DUT(huif); 
    test PROG(CLK, huif); 
endmodule

program test (
  input logic CLK, 
  hazard_unit_if.tb huif
);
    int test_case_num = 0; 

    initial begin
       huif.ihit = 1'b0;
       huif.dhit = 1'b0;
       huif.halt = 1'b0;
       huif.ex_regWEN = 1'b0;
       huif.mem_regWEN = 1'b0;
       huif.id_rs = '0;
       huif.id_rt = '0;
       huif.ex_rd = '0;
       huif.mem_rd = '0;
       huif.zero = 1'b0;
       huif.mem_pcsrc = PCSRC_PC4;
       repeat(2)@(posedge CLK);
       test_case_num ++;

       huif.ex_regWEN = 1'b1;
       huif.id_rs = 5'd5;
       huif.ex_rd = 5'd5;
       repeat(2)@(posedge CLK);
       test_case_num ++;

       huif.ihit = 1'b1;
       @(posedge CLK);
       huif.ihit = 1'b0;
       test_case_num ++;

       huif.mem_pcsrc = PCSRC_BEQ;
       huif.zero = 1'b1;
       repeat(2)@(posedge CLK);
       test_case_num ++;

       huif.zero = 1'b0;
       repeat(2)@(posedge CLK);
       test_case_num ++;

    end


endprogram 
