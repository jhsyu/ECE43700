`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "dp_types_pkg.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*; 


interface hazard_unit_if;
    // input of hazard unit, bypassing hazards. 
    logic dhit, ihit, phit, halt, ex_regWEN, mem_regWEN;
    regbits_t id_rs, id_rt, ex_rd, mem_rd; 


    // input of hazard unit, branch prediction. 
    logic zero; 
    pcsrc_t mem_pcsrc;


    // output of hazard unit. 
    logic if_id_en, id_ex_en, ex_mem_en, mem_wb_en; 
    logic if_id_flush, id_ex_flush, ex_mem_flush, mem_wb_flush; 
    logic pcen; 
    logic dmemREN; 
    branch_pred_state_t bp_stat; 

    modport hu (
        input   dmemREN, halt, ex_regWEN, mem_regWEN, 
                id_rs, id_rt, ex_rd, mem_rd,  
                zero, mem_pcsrc, dhit, ihit, bp_stat, 
        output  pcen, phit, 
                if_id_en, id_ex_en, ex_mem_en, mem_wb_en, 
                if_id_flush, id_ex_flush, ex_mem_flush, mem_wb_flush
    ); 
    modport tb (
        output  dmemREN, halt, ex_regWEN, mem_regWEN, 
                id_rs, id_rt, ex_rd, mem_rd,  
                zero, mem_pcsrc, dhit, ihit, 
        input   pcen, phit, 
                if_id_en, id_ex_en, ex_mem_en, mem_wb_en, 
                if_id_flush, id_ex_flush, ex_mem_flush, mem_wb_flush
    ); 
endinterface

`endif
