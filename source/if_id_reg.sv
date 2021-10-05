`include "pipeline_reg_if.vh"
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module if_id_reg (
	input logic CLK, nRST, 
	pipeline_reg_if.if_id_reg rif
);
	always_ff @( posedge CLK, negedge nRST) begin
		if (~nRST) begin
			rif.if_id_out <= if_id_t'(0); 
		end
		else if (rif.if_id_en && rif.if_id_flush) begin 
			rif.if_id_out <= if_id_t'(0); 
		end
		else if (rif.if_id_en) begin
			rif.if_id_out <= rif.if_id_in; 
		end
		else begin
			rif.if_id_out <= rif.if_id_out; 
		end
	end
endmodule
