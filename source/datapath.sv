/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"


module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import dp_types_pkg::*;

  // interfaces
  register_file_if rfif(); 
  alu_if aluif(); 
  control_unit_if cuif(); 
  request_unit_if ruif(); 

  // extension. 
  word_t imm32; 
  always_comb begin : EXT
    imm32 = {16'b0, dpif.imemload[15:0]};         // default is zero ext.
    if (cuif.extsel) begin                        // signed ext.
      if (dpif.imemload[15]) begin                     // negative.
        imm32 = {16'hFFFF, dpif.imemload[15:0]};  
      end
      else imm32 = {16'b0, dpif.imemload[15:0]};  // positive. 
    end
    else begin                                    // zero extention. 
      imm32 = {16'b0, dpif.imemload[15:0]}; 
    end
  end

  // PC
  parameter PC_INIT = 0;
  word_t cpc, npc, pc4, jaddr, baddr; 
  assign pc4 = cpc + 4; 
  assign jaddr = {pc4[31:28], dpif.imemload[25:0], 2'b0}; 
  assign baddr = pc4 + (imm32 << 2); 
  always_ff @(posedge CLK, negedge nRST) begin : PC
    if (~nRST) begin
      cpc <= PC_INIT; 
    end
    else begin
      cpc <= npc; 
    end
  end

  always_comb begin : PC_MUX
    casez (cuif.pcsrc)
        PCSRC_CPC: npc = cpc; 
        PCSRC_NPC: npc = pc4;
        PCSRC_REG: npc = rfif.rdat1; 
        PCSRC_JAL: npc = jaddr; 
        PCSRC_IMM: npc = baddr; 
      default: 
        npc = pc4; 
    endcase
    if (~dpif.ihit) begin
      npc = cpc;  // stall the increment on pc when instruction is not ready. 
    end
  end
  // input of register file. 
  assign rfif.WEN = cuif.regWEN; 
  assign rfif.wsel =  (cuif.regdst == REGDST_RD) ? dpif.imemload[15:11] : 
                      (cuif.regdst == REGDST_RT) ? dpif.imemload[20:16] : 
                      (cuif.regdst == REGDST_RA) ? regbits_t'(5'd31) : regbits_t'(5'd0); 
  assign rfif.rsel1 = dpif.imemload[25:21]; 
  assign rfif.rsel2 = dpif.imemload[20:16]; 
  assign rfif.wdat = (cuif.regsrc == REGSRC_ALU) ? aluif.port_o : 
                     (cuif.regsrc == REGSRC_MEM) ? dpif.dmemload: 
                     (cuif.regsrc == REGSRC_LUI) ? {dpif.imemload[15:0], 16'b0}: pc4; 
  // input of alu. 
  assign aluif.port_a = rfif.rdat1; 
  assign aluif.port_b = (cuif.alusrc == ALUSRC_REG) ? rfif.rdat2 : imm32; 
  assign aluif.aluop = cuif.aluop; 
  // input of control unit. 
  assign cuif.opcode = opcode_t'(dpif.imemload[31:26]); 
  assign cuif.funct = funct_t'(dpif.imemload[5:0]); 
  assign cuif.ihit = dpif.ihit; 
  assign cuif.dhit = dpif.dhit; 
  assign cuif.zero = aluif.z; 
  // input of request unit. 
  assign ruif.ihit = dpif.ihit; 
  assign ruif.dhit = dpif.dhit; 
  assign ruif.dREN = cuif.dREN; 
  assign ruif.dWEN = cuif.dWEN; 
  // datapath cache interface connections. 
  assign dpif.imemREN = ruif.imemREN; 
  assign dpif.imemaddr = cpc; 
  assign dpif.dmemREN = ruif.dmemREN;
  assign dpif.dmemWEN = ruif.dmemWEN; 
  assign dpif.dmemstore = rfif.rdat2; 
  assign dpif.dmemaddr = aluif.port_o; 

  always_ff @(posedge CLK, negedge nRST) begin : HALT_FF
    if (~nRST) begin
      dpif.halt <= 1'b0; 
    end
    else begin
      dpif.halt <= cuif.halt | dpif.halt; 
    end
  end


  // register file
  register_file rf(.CLK(CLK), .nRST(nRST), .rfif(rfif)); 
  // alu. 
  alu alu0 (.aluif(aluif)); 
  // control unit. 
  control_unit cu (cuif); 
  // request unit 
  request_unit ru (.CLK(CLK), .nRST(nRST), .ruif(ruif)); 

endmodule
