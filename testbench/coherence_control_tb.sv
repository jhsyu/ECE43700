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
    @(negedge CLK)
    nRST = 0;
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
    #(PERIOD); 
    nRST = 1;
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

  task automatic ram_write_response(); 
    wait(ccif.ramWEN); 
    ccif.ramstate = BUSY; 
    ccif.ramstore = 32'hDEFADEFA; 
    #(PERIOD); 
    @(negedge CLK); 
    ccif.ramstate = ACCESS; 
    @(negedge CLK); 
    ccif.ramstate = FREE; 
  endtask

  //task automatic cache_transfer(logic dst, word_t data); 
  //  @(negedge CLK); 
  //  ccif.dstore[~dst] = data; 
//
  //endtask


  /*
    test 1: P0 I->S | P1 I/S;
    test 2: P0 I->S | P1 M->S;
    test 3: P0 I->M | P1 I;
    test 4: P0 I->M | P1 S->I;
    test 5: P0 I->M | P1 M->I;
    test 6: P0 S->M | P1 I->I;
    test 7: P0 S->M | P1 S->I;
    test 8: P0 M->I
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

    test_case_num ++; 
    test_case_info = "test 2: P0 I->S | P1 M->S"; 
    @(negedge CLK);
    cif0.dREN = 1;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 0;
    wait(ccif.ccwait[1]); 
    @(negedge CLK); 
    cif1.cctrans = 1'b1; 
    cif1.dstore = 32'hDEFADEFA; 
    wait(ccif.dload[0] == ccif.dstore[1]); 
    ram_write_response(); 
    cif1.dstore = 32'hDEADDEAD;
    wait(ccif.dload[0] == ccif.dstore[1]);  
    ram_write_response(); 
    reset_signals();  

    test_case_num ++; 
    test_case_info = "test 3: P0 I->M | P1 I->I";
    cif0.dREN = 1; // allocate first
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 1;
    ram_read_response(32'h3);
    wait(ccif.dload[0] == 32'h3); 
    cif0.daddr = {26'h0, 3'b000, 1'b1, 2'b00};
    ram_read_response(32'h4);
    wait(ccif.dload[0] == 32'h4); 
    reset_signals();
    // cctrans[0] maintiains 1, state machine goes to snp again.
 

    test_case_num ++; 
    test_case_info = "test 4: P0 I->M | P1 S->I"; 
    // expect ccinv in snp states. 
    cif0.dREN = 1; // allocate first
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 1;
    wait(ccif.ccinv[1]); 
    ram_read_response(32'h5);
    wait(ccif.dload[0] == 32'h5); 
    cif0.daddr = {26'h0, 3'b000, 1'b1, 2'b00};
    ram_read_response(32'h6);
    wait(ccif.dload[0] == 32'h6); 
    reset_signals();



    test_case_num ++; 
    test_case_info = "test 5: P0 I->M | P1 M->I"; 
    // no updates to MEM. 
    cif0.dREN = 1;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 1;
    cif1.cctrans = 1;
    wait(ccif.ccinv[1]); 
    cif1.dstore = 32'hDEADBEEF;
    wait(ccif.dload[0]==32'hDEADBEEF); 
    cif1.dstore = 32'hBEEFBEEF; 
    wait(ccif.dload[0]==32'hBEEFBEEF); 
    reset_signals();

    test_case_num ++; 
    test_case_info = "test 6: P0 S->M | P1 I->I"; 
    cif0.dREN = 0;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 1;
    reset_signals(); 


    test_case_num ++; 
    test_case_info = "test 7: P0 S->M | P1 S->I"; 
    cif0.dREN = 0;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.ccwrite = 1;
    cif1.cctrans = 1; 
    wait(ccif.ccinv[1]); 
    // expect goes to inv state.
    reset_signals(); 


    test_case_num ++; 
    test_case_info = "test 8: P0 conflict miss."; 
    // expect wb state.
    cif0.dWEN = 1;
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.cctrans = 1;
    cif0.dstore = 32'h7; 
    ram_write_response(); 
    cif0.daddr = {26'h0, 3'b000, 1'b0, 2'b00};
    cif0.dstore = 32'h8; 
    ram_write_response(); 
    cif0.dWEN = 0; 
    cif0.dREN = 1; 
    ram_read_response(32'h9); 
    wait(ccif.dload[0] == 32'h9); 
    ram_read_response(32'h10); 
    wait(ccif.dload[0] == 32'h10); 
    //#(PERIOD * 20);
    $stop;
  end
endprogram