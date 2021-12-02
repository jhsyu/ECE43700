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
`include "pipeline_reg_if.vh"
`include "hazard_unit_if.vh"
`include "forwarding_if.vh"
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
  alu_if           aluif(); 
  control_unit_if  cuif(); 
  request_unit_if  ruif(); 
  pipeline_reg_if  rif();
  hazard_unit_if   huif(); 
  forwarding_if    fwif();

  // pipeline latches. 
  if_id_reg if_id (.CLK(CLK), .nRST(nRST), .rif(rif)); 
  id_ex_reg id_ex (.CLK(CLK), .nRST(nRST), .rif(rif)); 
  ex_mem_reg ex_mem (.CLK(CLK), .nRST(nRST), .rif(rif)); 
  mem_wb_reg mem_wb (.CLK(CLK), .nRST(nRST), .rif(rif)); 

  // forwarding signals
  logic [1:0] forwardA; 
  logic [1:0] forwardB; 

  // signal for stalling until dhit for lw and sw
  logic mem_op_stall;
  //assign mem_op_stall = (((opcode_t'(rif.ex_mem_out.imemload[31:26]) == SW) || (opcode_t'(rif.ex_mem_out.imemload[31:26]) == LW)) && ~dpif.dhit); 
  assign mem_op_stall = (((opcode_t'(rif.ex_mem_out.imemload[31:26]) == SW) ||
                          (opcode_t'(rif.ex_mem_out.imemload[31:26]) == LW) ||
                          (opcode_t'(rif.ex_mem_out.imemload[31:26]) == SC) ||
                          (opcode_t'(rif.ex_mem_out.imemload[31:26]) == LL)) && ~dpif.dhit); 

  // forwarding unit.
  forwarding fwding (.fwif(fwif));

  // stall signals
  logic stall; 
  // IF (Instruction Fetch): PC update. 
  logic halt; 
  assign halt = opcode_t'(dpif.imemload[31:26]) == HALT; 
  parameter PC_INIT = 0;
  word_t cpc, npc, pc4; 
  assign pc4 = cpc + 4; 
  always_ff @(posedge CLK, negedge nRST) begin : PC
    if (~nRST) begin
      cpc <= PC_INIT; 
    end
    else begin
      cpc <= npc; 
    end
  end
    
  assign dpif.imemaddr = cpc; 
  assign dpif.imemREN = 1'b1;

  // IF/ID pipeline register connections. 
  assign rif.if_id_in.imemload = (dpif.ihit) ? dpif.imemload : word_t'(0); 
  assign rif.if_id_in.pc = cpc; 
  assign rif.if_id_in.pc4 = pc4;
  assign rif.if_id_in.npc = npc; 

  // control unit: 
  assign cuif.opcode = opcode_t'(rif.if_id_out.imemload[31:26]); 
  assign cuif.funct = funct_t'(rif.if_id_out.imemload[5:0]); 
  // EXT unit: 
  word_t imm32; 
  always_comb begin : EXT
    imm32 = {16'b0, rif.if_id_out.imemload[15:0]};          // default is zero ext.
    if (cuif.extsel) begin                              // signed ext.
      if (rif.if_id_out.imemload[15]) begin                      // negative.
        imm32 = {16'hFFFF, rif.if_id_out.imemload[15:0]};  
      end
      else imm32 = {16'b0, rif.if_id_out.imemload[15:0]};  // positive. 
    end
    else begin                                    // zero extention. 
      imm32 = {16'b0, rif.if_id_out.imemload[15:0]}; 
    end
  end

  word_t ex_mem_wdat, mem_wb_wdat, rdat1_fwd, rdat2_fwd;
  assign ex_mem_wdat = (rif.ex_mem_out.regsrc == REGSRC_ALU) ? rif.ex_mem_out.alu_out : 
                       (rif.ex_mem_out.regsrc == REGSRC_LUI) ? rif.ex_mem_out.lui_ext: rif.ex_mem_out.pc4;
  assign mem_wb_wdat = (rif.mem_wb_out.regsrc == REGSRC_ALU) ? rif.mem_wb_out.alu_out : 
                       (rif.mem_wb_out.regsrc == REGSRC_MEM) ? rif.mem_wb_out.dload: 
                       (rif.mem_wb_out.regsrc == REGSRC_LUI) ? rif.mem_wb_out.lui_ext: rif.mem_wb_out.pc4;
  assign rdat1_fwd = (forwardA == 2'b10) ? ex_mem_wdat : // instead of just alu_out
		     (forwardA == 2'b01) ? mem_wb_wdat : rif.id_ex_out.rdat1;
  assign rdat2_fwd = (forwardB == 2'b10) ? ex_mem_wdat : 
		     (forwardB == 2'b01) ? mem_wb_wdat : rif.id_ex_out.rdat2;
   
  // register file connections. 
  assign rfif.WEN = rif.mem_wb_out.regWEN; 
  assign rfif.wsel =  rif.mem_wb_out.regtbw; 
  assign rfif.rsel1 = regbits_t'(rif.if_id_out.imemload[25:21]); 
  assign rfif.rsel2 = regbits_t'(rif.if_id_out.imemload[20:16]); 
  assign rfif.wdat = mem_wb_wdat;

  // ID/EX Connections. 
  assign rif.id_ex_in.imemload = rif.if_id_out.imemload; 
  assign rif.id_ex_in.pc = rif.if_id_out.pc; 
  assign rif.id_ex_in.pc4 = rif.if_id_out.pc4; 
  assign rif.id_ex_in.rdat1 = rfif.rdat1; 
  assign rif.id_ex_in.rdat2 = rfif.rdat2; 
  assign rif.id_ex_in.rt = rif.if_id_out.imemload[20:16]; 
  assign rif.id_ex_in.rd = rif.if_id_out.imemload[15:11]; 
  assign rif.id_ex_in.halt = cuif.halt;
  assign rif.id_ex_in.regsrc = cuif.regsrc; 
  assign rif.id_ex_in.regdst = cuif.regdst; 
  assign rif.id_ex_in.imm32 = imm32; 
  assign rif.id_ex_in.regWEN = cuif.regWEN; 
  assign rif.id_ex_in.dREN = cuif.dREN; 
  assign rif.id_ex_in.dWEN = cuif.dWEN; 
  assign rif.id_ex_in.alusrc = cuif.alusrc; 
  assign rif.id_ex_in.aluop = cuif.aluop;
  assign rif.id_ex_in.pcsrc = cuif.pcsrc; 
  assign rif.id_ex_in.npc = rif.if_id_out.npc;  
  assign rif.id_ex_in.datomic = cuif.datomic; 

  // EX stage. 
  // ALU input. 
  assign aluif.aluop = rif.id_ex_out.aluop;  
  assign aluif.port_a = rdat1_fwd; 
  assign aluif.port_b = (rif.id_ex_out.alusrc == ALUSRC_REG) ? rdat2_fwd : rif.id_ex_out.imm32; 

  // deciding baddr and jaddr. 
  assign rif.ex_mem_in.jaddr = {rif.id_ex_out.pc4[31:28], rif.id_ex_out.imemload[25:0], 2'b0}; 
  assign rif.ex_mem_in.baddr = rif.id_ex_out.pc4 + (rif.id_ex_out.imm32 << 2); 

  // lui ext. 
  assign rif.ex_mem_in.lui_ext = (rif.id_ex_out.regsrc == REGSRC_LUI) ? {rif.id_ex_out.imemload[15:0], 16'b0} : word_t'(32'b0); 

  // decide regtbw. 
  assign rif.ex_mem_in.regtbw = (rif.id_ex_out.regdst == REGDST_RD) ? rif.id_ex_out.imemload[15:11] : 
                            (rif.id_ex_out.regdst == REGDST_RT) ? rif.id_ex_out.imemload[20:16] : 
                            (rif.id_ex_out.regdst == REGDST_RA) ? regbits_t'(5'd31) : regbits_t'(5'd0); 

  // EX/MEM latch connections. 
  assign rif.ex_mem_in.imemload = rif.id_ex_out.imemload; 
  assign rif.ex_mem_in.pc = rif.id_ex_out.pc; 
  assign rif.ex_mem_in.pc4 = rif.id_ex_out.pc4; 
  assign rif.ex_mem_in.alu_out = aluif.port_o; 
  assign rif.ex_mem_in.rdat1 = rdat1_fwd; 
  assign rif.ex_mem_in.rdat2 = rdat2_fwd; 
  assign rif.ex_mem_in.halt = rif.id_ex_out.halt; 
  assign rif.ex_mem_in.regsrc = rif.id_ex_out.regsrc; 
  assign rif.ex_mem_in.imm32 = rif.id_ex_out.imm32; 
  assign rif.ex_mem_in.regWEN = rif.id_ex_out.regWEN; 
  assign rif.ex_mem_in.dREN = rif.id_ex_out.dREN; 
  assign rif.ex_mem_in.dWEN = rif.id_ex_out.dWEN; 
  assign rif.ex_mem_in.zero = aluif.z; 
  assign rif.ex_mem_in.pcsrc = rif.id_ex_out.pcsrc;
  assign rif.ex_mem_in.npc = rif.id_ex_out.npc;
  assign rif.ex_mem_in.rdat2_fwd = rdat2_fwd;
  assign rif.ex_mem_in.datomic = rif.id_ex_out.datomic; 

  // PC

  always_comb begin : PC_MUX
    if (huif.pcen && dpif.ihit && ~mem_op_stall) begin
      casez (rif.ex_mem_out.pcsrc)
        PCSRC_REG: npc = rif.ex_mem_out.rdat1; 
        PCSRC_JAL: npc = rif.ex_mem_out.jaddr; 
        PCSRC_BEQ: begin 
          npc = (rif.ex_mem_out.zero) ? rif.ex_mem_out.baddr : pc4; 
          if(rif.mem_wb_out.datomic && rif.mem_wb_out.dWEN) begin
            // sc fails. write to register file.
            // sc rt
            // beq rs/rt
            if(rif.mem_wb_out.imemload[20:16] == rif.ex_mem_out.imemload[25:21]) begin
              npc = (rfif.wdat == rif.ex_mem_out.rdat1) ? rif.ex_mem_out.baddr : pc4; 
            end
            else if (rif.mem_wb_out.imemload[20:16] == rif.ex_mem_out.imemload[20:16]) begin
              npc = (rfif.wdat == rif.ex_mem_out.rdat2) ? rif.ex_mem_out.baddr : pc4; 
            end
          end
        end
        PCSRC_BNE: begin 
          npc = (rif.ex_mem_out.zero) ? pc4 : rif.ex_mem_out.baddr;
          if(rif.mem_wb_out.datomic && rif.mem_wb_out.dWEN) begin
            // sc fails. write to register file.
            // sc rt
            // beq rs/rt
            if(rif.mem_wb_out.imemload[20:16] == rif.ex_mem_out.imemload[25:21]) begin
              npc = (rfif.wdat == rif.ex_mem_out.rdat1) ? pc4 : rif.ex_mem_out.baddr; 
            end
            else if (rif.mem_wb_out.imemload[20:16] == rif.ex_mem_out.imemload[20:16]) begin
              npc = (rfif.wdat == rif.ex_mem_out.rdat2) ? pc4 : rif.ex_mem_out.baddr; 
            end
            else npc = (rif.ex_mem_out.zero) ? pc4 : rif.ex_mem_out.baddr;
          end
        end
        default:   npc = pc4; 
      endcase
    end
    else begin
      npc = cpc; 
    end
  end

  // MEM/WB latch connections. 
  assign rif.mem_wb_in.imemload = rif.ex_mem_out.imemload; 
  assign rif.mem_wb_in.dload = dpif.dmemload; 
  assign rif.mem_wb_in.alu_out = rif.ex_mem_out.alu_out; 
  assign rif.mem_wb_in.lui_ext = rif.ex_mem_out.lui_ext; 
  assign rif.mem_wb_in.regtbw = rif.ex_mem_out.regtbw; 
  assign rif.mem_wb_in.halt = rif.ex_mem_out.halt; 
  assign rif.mem_wb_in.regsrc = rif.ex_mem_out.regsrc; 
  assign rif.mem_wb_in.regWEN = rif.ex_mem_out.regWEN; 
  assign rif.mem_wb_in.imm32 = rif.ex_mem_out.imm32; 
  assign rif.mem_wb_in.baddr = rif.ex_mem_out.baddr; 
  assign rif.mem_wb_in.rdat2 = rif.ex_mem_out.rdat2; 
  assign rif.mem_wb_in.pc4 = rif.ex_mem_out.pc4; 
  assign rif.mem_wb_in.pc = rif.ex_mem_out.pc;
  assign rif.mem_wb_in.npc = rif.ex_mem_out.npc; 
  assign rif.mem_wb_in.datomic = rif.ex_mem_out.datomic; 
  assign rif.mem_wb_in.dWEN = rif.ex_mem_out.dWEN; 
  // cpu tracker signals.
  opcode_t cpu_tracker_opcode;
  assign cpu_tracker_opcode = opcode_t'(rif.mem_wb_out.imemload[31:26]);  
  funct_t cpu_tracker_funct; 
  assign cpu_tracker_funct = funct_t'(rif.mem_wb_out.imemload[5:0]);
  regbits_t cpu_tracker_rs, cpu_tracker_rt; 
  assign cpu_tracker_rs = regbits_t'(rif.mem_wb_out.imemload[25:21]);
  assign cpu_tracker_rt = regbits_t'(rif.mem_wb_out.imemload[20:16]);
  logic wb_enable; 
  assign wb_enable = rif.mem_wb_en;

  // datapath cache interface connections. 

  assign dpif.dmemREN = rif.ex_mem_out.dREN;
  assign dpif.dmemWEN = rif.ex_mem_out.dWEN;
  assign dpif.dmemaddr = rif.ex_mem_out.alu_out; 
  //assign dpif.dmemstore = rif.ex_mem_out.rdat2_fwd;
  assign dpif.datomic = rif.ex_mem_out.datomic; 
  always_comb begin
    dpif.dmemstore = rif.ex_mem_out.rdat2;
    if (rif.mem_wb_out.dWEN && rif.mem_wb_out.datomic &&
        regbits_t'(rif.mem_wb_out.imemload[20:16]) == regbits_t'(rif.ex_mem_out.imemload[20:16])) begin
      dpif.dmemstore = rfif.wdat; 
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
      dpif.halt <= 0;
    end
    else begin
      dpif.halt <= rif.mem_wb_out.halt | dpif.halt;
    end
  end


  // hazard unit interface connections. 
  assign huif.dhit = dpif.dhit; 
  assign huif.ihit = dpif.ihit; 
  assign huif.halt = rif.mem_wb_out.halt || dpif.halt; 
  assign huif.ex_regWEN = rif.id_ex_out.regWEN; 
  assign huif.mem_regWEN = rif.ex_mem_out.regWEN; 
  assign huif.id_rs = rfif.rsel1; 
  assign huif.id_rt = rfif.rsel2; 
  assign huif.ex_rd = rif.ex_mem_in.regtbw; 
  assign huif.mem_rd = rif.ex_mem_out.regtbw; 
  assign huif.zero = rif.ex_mem_out.zero; 
  assign huif.mem_pcsrc = rif.ex_mem_out.pcsrc; 
  assign huif.dmemREN = rif.id_ex_out.dREN;
  assign rif.if_id_en = (huif.if_id_en & (dpif.ihit | dpif.dhit) & ~mem_op_stall); 
  assign rif.id_ex_en = (huif.id_ex_en & (dpif.ihit | dpif.dhit) & ~mem_op_stall); 
  assign rif.ex_mem_en = (huif.ex_mem_en & (dpif.ihit | dpif.dhit) & ~mem_op_stall); 
  assign rif.mem_wb_en = (huif.mem_wb_en & (dpif.ihit | dpif.dhit) & ~mem_op_stall); 
  assign rif.if_id_flush = huif.if_id_flush; 
  assign rif.id_ex_flush = huif.id_ex_flush; 
  assign rif.ex_mem_flush = huif.ex_mem_flush; 
  assign rif.mem_wb_flush = huif.mem_wb_flush; 


  // forwarding unit interface connections
  assign fwif.mem_wb_regWEN = rif.mem_wb_out.regWEN;
  assign fwif.ex_mem_regWEN = rif.ex_mem_out.regWEN;
  assign fwif.mem_wb_regtbw = rif.mem_wb_out.regtbw;
  assign fwif.ex_mem_regtbw = rif.ex_mem_out.regtbw;
  assign fwif.rs = regbits_t'(rif.id_ex_out.imemload[25:21]);
  assign fwif.rt = regbits_t'(rif.id_ex_out.imemload[20:16]);
  assign forwardA = fwif.forwardA;
  assign forwardB = fwif.forwardB; 

  opcode_t mem_opcode; 
  assign mem_opcode = opcode_t'(rif.ex_mem_out.imemload[31:26]);   

  // register file.
  register_file rf(.CLK(CLK), .nRST(nRST), .rfif(rfif)); 
  // alu. 
  alu alu0 (.aluif(aluif)); 
  // control unit. 
  control_unit cu (cuif); 
  // request unit. 
  request_unit ru (.CLK(CLK), .nRST(nRST), .ruif(ruif)); 
  // hazard unit. 
  hazard_unit hu (.huif(huif)); 

endmodule
