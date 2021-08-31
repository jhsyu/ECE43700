/**
 *  alu_fpga.sv
 * 
 *  Author  : Abhishek Bhaumick
 * 
 */

// interface
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*; 

module alu_fpga (
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR,
  output logic [7:0] LEDG
);

  word_t regB = 32'h0;
  logic [15:0] ledDisp;
  // SW[17]: set the port_a and port_b. 
  // SW[16]: port_b if 0; 
  //         port_o if 1. 
  // SW[15:0]: input to regB (port_b). 
  // LEDR[15:0]: SW[16]? port_o : port_b. 
  // LEDG[2:0]: {n,z,v}

  always_latch begin : setPortB
    if (SW[17] == 1'b1) begin
      regB = {16'h0, SW[15:0]};
    end else begin
      regB = regB;
    end
  end

  // interface
  alu_if aluif();

  // rf
  // alu alu_unit(KEY[0], aluif);
  alu alu_unit(aluif);

  assign aluif.port_a = {16'h0, SW[15:0]};
  assign aluif.port_b = {16'h0, regB[15:0]};
  assign aluif.aluop = aluop_t'(KEY[3:0]);

  assign LEDR[15:0] = (SW[16]) ? aluif.port_o[15:0] : aluif.port_b[15:0];
  assign LEDR[17:16] = SW[17:16];

  assign LEDG[0] = aluif.v;
  assign LEDG[1] = aluif.z;
  assign LEDG[2] = aluif.n;

  assign LEDG[7:4] = aluif.aluop;

endmodule