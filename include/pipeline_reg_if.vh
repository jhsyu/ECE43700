/*
	Author: Jiahao Xu
	Email: xu1392@purdue.edu
	interface for pipeline latches, 
	IF/ID, ID/EX, EX/MEM, MEM_WB
*/
`ifndef PIPELINE_REG_IF_VH
`define PIPELINE_REG_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

interface pipeline_reg_if;
	import cpu_types_pkg::*; 
	import dp_types_pkg::*; 
	// latch enable and flush signals. 
	// en[4] for if/id, respectively. 
	logic if_id_en, id_ex_en, ex_mem_en, mem_wb_en; 
	logic if_id_flush, id_ex_flush, ex_mem_flush, mem_wb_flush; 
	// I/O varibles for IF/ID latch.  
	if_id_t if_id_in, if_id_out; 
	id_ex_t id_ex_in, id_ex_out; 
	ex_mem_t ex_mem_in, ex_mem_out; 
	mem_wb_t mem_wb_in, mem_wb_out; 

	modport if_id_reg(
		input if_id_en, if_id_flush, if_id_in, 
		output if_id_out
	); 

	modport id_ex_reg(
		input id_ex_en, id_ex_flush, id_ex_in, 
		output id_ex_out
	); 

	modport ex_mem_reg(
		input ex_mem_en, ex_mem_flush, ex_mem_in, 
		output ex_mem_out
	);

	modport mem_wb_reg(
		input mem_wb_en, mem_wb_flush, mem_wb_in, 
		output mem_wb_out
	); 
endinterface

`endif //PIPELINE_REG_IF_VH
