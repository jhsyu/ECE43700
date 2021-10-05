`include "pipeline_reg_if.vh"
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module mem_wb_reg (
	input logic CLK, nRST, 
	pipeline_reg_if.mem_wb_reg rif 
	
);
	always_ff @( posedge CLK, negedge nRST) begin
		if (~nRST) begin
			rif.mem_wb_out <= id_ex_t'(0); 
		end
		else if (rif.mem_wb_en && rif.mem_wb_flush) begin
			rif.mem_wb_out <= id_ex_t'(0); 
		end
		else if (rif.mem_wb_en) begin
			rif.mem_wb_out <= rif.mem_wb_in; 
		end
		else begin
			rif.mem_wb_out <= rif.mem_wb_out; 
		end
	end
endmodule
