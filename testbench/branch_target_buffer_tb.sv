`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "branch_target_buffer_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*; 

module branch_target_buffer_tb;
	branch_target_buffer_if btbif(); 
	parameter PERIOD = 10;

	logic CLK = 0, nRST;
	always #(PERIOD/2) CLK++;

	branch_target_buffer DUT (.CLK(CLK), .nRST(nRST), .btbif(btbif)); 
	test PROG(.CLK(CLK), .nRST(nRST), .tbif(btbif)); 
endmodule

program test (
	input logic CLK, 
	output logic nRST, 
	branch_target_buffer_if.tb tbif
); 
	int test_case_num = 0; 
	initial begin
		tbif.rsel = branch_pred_frame_t'('hBAD1BAD1); 
		tbif.wsel = branch_pred_frame_t'('hDEADBEEF); 
		tbif.wdat = branch_pred_frame_t'({BPRED_NS, word_t'(0)}); 
		tbif.wen = 1'b0; 
		nRST = 1'b1; 

		// test 0: Reset.
		nRST = 1'b0;
		@(posedge CLK);   
		@(posedge CLK);   

		// Test case 1: write buffer.
		@(posedge CLK); 
		tbif.wen = 1'b1; 
		@(posedge CLK); 
		tbif.wen = 1'b0; 
		// Test case 2: read target.
		tbif.rsel = tbif.wsel; 
		@(posedge CLK);  
		nRST = 1'b1; 
		@(posedge CLK); 
	end
	
endprogram

