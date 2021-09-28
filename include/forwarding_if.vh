`ifndef FORWARDING_IF_VH
`define FORWARDING_IF_VH
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*; 

interface forwarding_if;  
    logic mem_wb_regWEN, ex_mem_regWEN;
    logic [1:0] forwardA, forwardB;
    regbits_t mem_wb_regtbw, ex_mem_regtbw, rs, rt;
    

    modport fw (
        input   mem_wb_regWEN, ex_mem_regWEN, mem_wb_regtbw, ex_mem_regtbw, rs, rt,
        output  forwardA, forwardB
    ); 

    modport tb (
        output  mem_wb_regWEN, ex_mem_regWEN, mem_wb_regtbw, ex_mem_regtbw, rs, rt,
        input   forwardA, forwardB
    ); 
endinterface
`endif 
