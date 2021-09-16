`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*; 

interface control_unit_if; 
    logic ihit, dhit; 
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
    pcsrc_t pcsrc; 
    logic zero; 

    modport cu (
        input   ihit, dhit, zero, opcode, funct,
        output  aluop, halt,
                regsrc, regdst, regWEN, 
                extsel, 
                alusrc, 
                dREN, dWEN, 
                pcsrc
    ); 

    modport tb (
        output  ihit, dhit, zero, opcode, funct,
        input   aluop, halt,
                regsrc, regdst, regWEN, 
                extsel, 
                alusrc, 
                dREN, dWEN, 
                pcsrc
    ); 
endinterface
`endif 
