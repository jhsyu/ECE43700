`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
interface request_unit_if; 
    logic ihit, dhit, dREN, dWEN; 
    logic imemREN, dmemREN, dmemWEN;

    modport ru (
        input   ihit, dhit, dREN, dWEN, 
        output  imemREN, dmemREN, dmemWEN
    );  
    modport tb (
        output  ihit, dhit, dREN, dWEN, 
        input   imemREN, dmemREN, dmemWEN
    );  
endinterface
`endif