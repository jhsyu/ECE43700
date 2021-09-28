`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "dp_types_pkg.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*; 
import dp_types_pkg::*; 


interface hazard_unit_if;
    // input of hazard unit, bypassing hazards. 
    logic dhit, ihit, halt, ex_regWEN, mem_regWEN;
    regbits_t id_rs, id_rt, mem_rd, wb_rd; 


    // input of hazard unit, branch prediction. 
    logic zero; 
    pcsrc_t mem_pc_src;


    // output of hazard unit. 
    logic en[3:0], flush[3:0];  // en[3] and flush[3] for if/id. respectively. 
    logic pcen; 

    // intermediate signals. 
    logic phit;                 // indicating if prediction is correct. 
    modport harzard_unit (
        input   dhit, ihit, halt, ex_regWEN, mem_regWEN, 
                id_rs, id_rt, mem_rd, wb_rd, 
                zero, mem_pc_src, 
        output  en, flush, pcen
    ); 
endinterface

`endif