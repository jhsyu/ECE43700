`ifndef BRANCH_PRED_IF_VH
`define BRANCH_PRED_IF_VH

`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

interface branch_pred_if;
    import cpu_types_pkg::*; 
    import dp_types_pkg::*; 

    logic phit;
    word_t cpc, pc4, baddr, npc; 

    // still need CLK and nRST
    
    modport bp (
        input   phit, pc4, baddr, 
        output  npc 
    ); 
    modport tb (
        output  phit, pc4, baddr, 
        input   npc 
    ); 
endinterface
`endif 
