`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file(
	input CLK, 
	input nRST, 
	register_file_if.rf rfif
);
	import cpu_types_pkg::*; 
	word_t [31:0] reg_curr, reg_next;
	always_ff @(negedge CLK, negedge nRST) begin
		// reg_curr <= reg_next; 
		if (~nRST) begin
			reg_curr <= '0;
		end
		else begin
			reg_curr <= reg_next; 
		end
	end

	always_comb begin
		reg_next = reg_curr; 
		// if wsel is not pointing to $0, write wdat to reg file.
		if (rfif.WEN && |rfif.wsel) begin
			reg_next[rfif.wsel] = rfif.wdat; 
		end
	end
	logic test_probe; 
	assign rfif.rdat1 = reg_curr[rfif.rsel1];
	assign rfif.rdat2 = reg_curr[rfif.rsel2]; 
	
endmodule

