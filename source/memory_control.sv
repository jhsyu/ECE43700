/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  assign ccif.iload = ccif.ramload;
  assign ccif.dload = ccif.ramload;
  assign ccif.ramstore = ccif.dstore;
  assign ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;

  always_comb begin
    ccif.iwait = 1'b1; 
    ccif.dwait = 1'b1; 
    if (ccif.ramstate == ACCESS) begin
      casez({ccif.iREN, ccif.dREN, ccif.dWEN})
        3'b100:         ccif.iwait = 1'b0; // only read instruction. 
        3'bz01, 3'bz10: ccif.dwait = 1'b0; // r/w on data. 
      endcase
    end
  end
  ramstate_t rstate; 
  // assign rstate = ccif.ramstate;
  always_ff @(posedge CLK or negedge nRST) begin
    if (~nRST) begin
      rstate <= ERROR; 
    end
    else begin
      rstate <= ccif.ramstate; 
    end
  end

  always_comb begin
    ccif.ramREN = 1'b0; 
    ccif.ramWEN = 1'b0; 
    if (rstate != ERROR) begin
      casez ({ccif.iREN, ccif.dREN, ccif.dWEN})
        3'b100, 3'bz10: ccif.ramREN = 1'b1; 
        3'bz01: ccif.ramWEN = 1'b1; 
      endcase
    end
  end


endmodule
