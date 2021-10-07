`ifndef BRANCH_PRED_IF_VH
`define BRANCH_PRED_IF_VH

`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

interface branch_predictor_if;
    import cpu_types_pkg::*; 
    import dp_types_pkg::*; 

    logic phit, loadEN; 
    logic [1:0]
    word_t cpc, pc4, baddr, npc; 

    // still need CLK and nRST
    
    modport bp (
        input   phit, loadEN, buf_load, pc4, 
        output  npc, wbuf 
    ); 
    modport tb (
        output  phit, pc4, loadEN, buf_load,
        input   npc, wbuf 
    ); 
endinterface
`endif 