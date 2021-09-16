`include "request_unit_if.vh"
`timescale 1ns/1ns

parameter PERIOD = 10;
module request_unit_tb; 
    logic CLK = 0; 
    logic nRST;
    always #(PERIOD/2) CLK++;
    request_unit_if ruif(); 

    request_unit DUT(CLK, nRST, ruif); 
    test PROG (CLK, nRST, ruif); 
endmodule

program test(
    input logic CLK, 
    output logic nRST, 
    request_unit_if.tb ruif
); 
    int test_case_num = 0; 
    initial begin
        ruif.ihit = 1'b0; 
        ruif.dhit = 1'b0; 
        ruif.dREN = 1'b0; 
        ruif.dWEN = 1'b0; 
        nRST = 1'b0; 
        // test case 0: reset. 
        @(negedge CLK); 
        #(PERIOD * 2); 
        nRST = 1'b1; 
        #(PERIOD); 
        test_case_num ++; 

        // test case 1: instruction read. 
        ruif.ihit = 1'b1; 
        #(PERIOD * 2); 
        test_case_num ++; 

        // test case 2: data read
        ruif.ihit = 1'b0; 
        ruif.dhit = 1'b0; 
        ruif.dREN = 1'b1; 
        ruif.dWEN = 1'b0; 
        #(PERIOD * 2); 
        ruif.dhit = 1'b1; 
        #(PERIOD * 2); 
        test_case_num ++; 

        // test case 2: data write
        ruif.ihit = 1'b0; 
        ruif.dhit = 1'b0; 
        ruif.dREN = 1'b0; 
        ruif.dWEN = 1'b1; 
        #(PERIOD * 2); 
        ruif.dhit = 1'b1; 
        #(PERIOD * 2); 
        test_case_num ++; 

        
    end
endprogram