/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (
    .CLK(CLK), 
    .v1(v1), 
    .v2(v2), 
    .v3(v3), 
    .nRST(nRST), 
    .tbif(rfif.tb)
  );
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
  input logic CLK, 
  input int v1,v2,v3,
  output logic nRST, 
  register_file_if.tb tbif
);
  import cpu_types_pkg::*;
  initial begin
    int test_case_num = 0; 
    // test case 0. reset DUT. 
    tbif.wsel = regbits_t'(0); 
    tbif.WEN = 1'b0; 
    tbif.wdat = word_t'('hdeadbeef); 
    tbif.rsel1 = regbits_t'(0);
    tbif.rsel2 = regbits_t'(0);
    nRST = 1'b0; 
    @(posedge CLK); 
    @(negedge CLK); 
    nRST = 1'b1; 
    test_case_num ++; 

    // test case 1. write v1 to $0. 
    @(negedge CLK); 
    tbif.WEN = 1'b1; 
    tbif.wdat = word_t'(v1);
    tbif.wsel = regbits_t'(0); 
    tbif.rsel1 = regbits_t'(0); 
    @(negedge CLK); 
    tbif.WEN = 1'b0;
    assert (tbif.rdat1 == word_t'(0)) $display("test case %d passed!", test_case_num); 
      else $error("test case 1 failed. expect %d, read %d", word_t'(0), tbif.rdat1);
    test_case_num ++; 

    // test case 2. write v1 to $1. 
    @(negedge CLK); 
    tbif.WEN = 1'b1; 
    tbif.wdat = word_t'(v1);
    tbif.wsel = regbits_t'(1); 
    tbif.rsel1 = regbits_t'(1); 
    @(negedge CLK); 
    tbif.WEN = 1'b0; 
    assert (tbif.rdat1 == word_t'(v1)) $display("test case %d passed!", test_case_num); 
    else $error("test case 2 failed. expect %d, read %d", word_t'(v1), tbif.rdat1);

    test_case_num ++; 

    // test case 3. write v2 to $31
    @(negedge CLK); 
    tbif.WEN = 1'b1; 
    tbif.wdat = word_t'(v2);
    tbif.wsel = regbits_t'(31); 
    tbif.rsel1 = regbits_t'(31); 
    @(negedge CLK); 
    tbif.WEN = 1'b0; 
    assert (tbif.rdat1 == word_t'(v2)) $display("test case %d passed!", test_case_num); 
    else $error("test case 3 failed. expect %d, read %d", word_t'(v2), tbif.rdat1);
    test_case_num ++; 

    // test case 4. overwrite v3 to $1. 
    @(negedge CLK); 
    tbif.WEN = 1'b1; 
    tbif.wdat = word_t'(v3);
    tbif.wsel = regbits_t'(1);
    tbif.rsel1 = regbits_t'(1);  
    @(negedge CLK); 
    tbif.WEN = 1'b0; 
    assert (tbif.rdat1 == word_t'(v3)) $display("test case %d passed!", test_case_num); 
    else $error("test case 3 failed. expect %d, read %d", word_t'(v3), tbif.rdat1);

    test_case_num ++; 
  end
endprogram
