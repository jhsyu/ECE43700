`ifndef ALU_IF_VH
`define ALU_IF_VH
`include "cpu_types_pkg.vh"

interface name;
    import cpu_types_pkg::*;
    /*
                    == INPUT ==
    aluop:  the opcode input to the ALU unit. 
    port_a: input port A, as the 1st input. 
    port_b: input port B, as the 2nd input. 
                    == OUTPUT ==
    port_o: output port of the ALU unit. 
    n:      negative flag, output. 
    z:      zero flag, output. 
    v:      overflow flag, output. 
    */
    aluop_t aluop; 
    word_t port_a, port_b, port_o; 
    logic n, z, v; 

    // ALU ports. 
    modport alu (
        input port_a, port_b, aluop, 
        output port_o, n, z, v
    ); 
    // Testbench ports. 
    modport tb (
        input port_o, n, z, v, 
        output port_a, port_b, aluop
    ); 
endinterface
endif