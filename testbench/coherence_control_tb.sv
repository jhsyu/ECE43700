`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "cache_control_if.vh"
`timescale 1ns/1ns
import cpu_types_pkg::*;


module coherence_control_tb;

    parameter PERIOD = 10;
    logic CLK = 0, nRST;

    always #(PERIOD/2) CLK++;

    caches_if cif0 ();
    caches_if cif1 ();
    cache_control_if ccif (cif0, cif1);
    coherence_control DUT(.CLK(CLK), .nRST(nRST), .ccif(ccif));
    test PROG (CLK, nRST);
    
endmodule


program test(input CLK, output logic nRST);
  parameter PERIOD = 10;
  integer test_case_num;
  string test_case_info;

  task automatic reset_signals;
    nRST = 1;
    cif0.iREN = '0;
    cif0.iaddr = '0;
    cif0.dREN = '0;
    cif0.dWEN = '0;
    cif0.dstore = '0;
    cif0.daddr = '0;
    cif0.ccwrite = '0;
    cif0.cctrans = '0;

    cif1.iREN = '0;
    cif1.iaddr = '0;
    cif1.dREN = '0;
    cif1.dWEN = '0;
    cif1.dstore = '0;
    cif1.daddr = '0;
    cif1.ccwrite = '0;
    cif1.cctrans = '0;

    ccif.ramload = 32'hBAD1BAD1;
    ccif.ramstate = FREE;
  endtask

  task automatic ram_read_response(word_t re_word);
    wait(ccif.ramREN);
    ccif.ramstate = BUSY;
    ccif.ramload = 32'hBAD1BAD1;
    #(PERIOD);
    @(negedge CLK);
    ccif.ramstate = ACCESS;
    ccif.ramload = re_word;
    @(negedge CLK);
    ccif.ramstate = FREE;
  endtask


  /*
    test 1: P0 I->S | P1 I/S;
    test 2: P0 I->S | P1 M->S;
    test 4: P0 I->M | P1 I->I;
    test 5: P0 I->M | P1 S->I;
    test 6: P0 I->M | P1 M->I;
    test 7: P0 S->M | P1 I->I;
    test 8: P0 S->M | P1 S->I;
    test 9: P0 M->I
  */

  initial begin
    reset_signals();
    test_case_num = 0;
    test_case_info = "NULL"; 
    nRST = 0;
    #(PERIOD * 2);
    @(negedge CLK);
    nRST = 1;

    // P0 I->S, memory provide the block
    // P1 I/S, no response
    @(negedge CLK);
    test_case_num++;
    test_case_info = "P0 I->S, P1 I->I"; 
    cif0.dREN = 1;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 0;
    ram_read_response(32'h1);
    cif0.daddr = {26'h0, 3'b000, 1'b1, 2'b00};
    ram_read_response(32'h2);
    reset_signals();
    #(PERIOD * 20);
    $stop;
  end
endprogram