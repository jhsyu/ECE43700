`include "pipeline_reg_if.vh"
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module id_ex_reg (
	input logic CLK, nRST, 
	pipeline_reg_if.id_ex_reg rif
);
	always_ff @( posedge CLK, negedge nRST) begin
		if (~nRST | rif.id_ex_flush) begin
			rif.id_ex_out <= id_ex_t'(0); 
		end
		else if (rif.id_ex_en) begin
			rif.id_ex_out <= rif.id_ex_in; 
		end
		else begin
			rif.id_ex_out <= rif.id_ex_out; 
		end
	end
endmodule

