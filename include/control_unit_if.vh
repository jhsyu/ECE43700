`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*; 

interface control_unit_if;  
    opcode_t opcode; 
    funct_t funct; 
    logic halt; 
    regsrc_t regsrc; 
    regdst_t regdst; 
    extsel_t extsel; 
    logic regWEN; 
    logic dREN, dWEN; 
    alusrc_t alusrc;
    aluop_t aluop; 
    logic zero; 

    modport cu (
        input   zero, opcode, funct,
        output  aluop, halt,
                regsrc, regdst, regWEN, 
                extsel, 
                alusrc, 
                dREN, dWEN
    ); 

    modport tb (
        output  zero, opcode, funct,
        input   aluop, halt,
                regsrc, regdst, regWEN, 
                extsel, 
                alusrc, 
                dREN, dWEN
    ); 
endinterface
`endif 
