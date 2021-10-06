`include "pipeline_reg_if.vh"
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module ex_mem_reg (
	input logic CLK, nRST, 
	pipeline_reg_if.ex_mem_reg rif
);
	always_ff @( posedge CLK, negedge nRST) begin
		if (~nRST) begin
			rif.ex_mem_out <= ex_mem_t'(0); 
		end
		else if (rif.ex_mem_en & rif.ex_mem_flush) begin
			rif.ex_mem_out <= ex_mem_t'(0); 
		end
		else if (rif.ex_mem_en) begin
			rif.ex_mem_out <= rif.ex_mem_in; 
		end
		else begin
			rif.ex_mem_out <= rif.ex_mem_out; 
		end
	end
endmodule