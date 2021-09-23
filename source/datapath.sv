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

  IF_ID_t  if_id_in, if_id_out;
  ID_EX_t  id_ex_in, id_ex_out; 
  EX_MEM_t ex_mem_in, ex_mem_out;
  MEM_WB_t mem_wb_in, mem_wb_out;

  // pipeline latches
  
  always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
      if_id_out <= '0; 
      id_ex_out <= '0; 
      ex_mem_out <= '0; 
      mem_wb_out <= '0; 
    end
    else if (dpif.ihit) begin
      if_id_out <= if_id_in; 
	    id_ex_out <= id_ex_in;
      ex_mem_out <= ex_mem_in; 
	    mem_wb_out <= mem_wb_in;
    end
    else begin
	    if_id_out <= if_id_out; 
	    id_ex_out <= id_ex_out;
      ex_mem_out <= ex_mem_out; 
	    mem_wb_out <= mem_wb_out;
    end
  end


   
  // new memory latching
  MEM_WB_DATA_t mem_wb_data_in, mem_wb_data_out;

  always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
      mem_wb_data_out <= '0;
    end
    else if (dpif.dhit) begin // latch enable on dhit for dload
      mem_wb_data_out <= mem_wb_data_in;
    end
    else begin
      mem_wb_data_out <= mem_wb_data_out;
    end
  end

  assign mem_wb_data_in.dload = dpif.dmemload;
  // use mem_wb_data_out.dload for wdat latch

  assign dpif.imemREN = 1'b1;
  assign dpif.dmemREN = ~dpif.dhit & ex_mem_out.dREN;
  assign dpif.dmemWEN = ~dpif.dhit & ex_mem_out.dWEN;
  // end of new memory latching


   

  // IF (Instruction Fetch): PC update. 
  // TODO: assign npc from mem_wb . 
  parameter PC_INIT = 0;
  logic cpc, npc, pc4; 
  assign pc4 = cpc + 4; 
  assign npc = ; 
  always_ff @(posedge CLK, negedge nRST) begin : PC
    if (~nRST) begin
      cpc <= PC_INIT; 
    end
    else begin
      cpc <= npc; 
    end
  end

  // IF/ID pipeline register connections. 
  assign if_id_in.imemload = dpif.imemload; 
  assign if_id_in.pc = cpc; 
  assign if_id_in.pc4 = pc4; 

  // control unit: 
  assign cuif.instr = word_t'(if_id_out.imemload); 
  // EXT unit: 
  word_t imm32; 
  always_comb begin : EXT
    imm32 = {16'b0, if_id_out.imemload[15:0]};          // default is zero ext.
    if (cuif.extsel) begin                              // signed ext.
      if (dpif.imemload[15]) begin                      // negative.
        imm32 = {16'hFFFF, dpif.imemload[15:0]};  
      end
      else imm32 = {16'b0, dpif.imemload[15:0]};  // positive. 
    end
    else begin                                    // zero extention. 
      imm32 = {16'b0, dpif.imemload[15:0]}; 
    end
  end

  // register file connections. 
  assign rfif.WEN = mem_wb_out.regWEN; 
  assign rfif.wsel =  mem_wb_out.regtbw; 
  assign rfif.rsel1 = if_id_out.imemload[25:21]; 
  assign rfif.rsel2 = if_id_out.imemload[20:16]; 
  assign rfif.wdat = (mem_wb_out.regsrc == REGSRC_ALU) ? mem_wb_out.alu_out : 
                     (mem_wb_out.regsrc == REGSRC_MEM) ? mem_wb_out.dmemload: 
                     (mem_wb_out.regsrc == REGSRC_LUI) ? mem_wb_out.lui_ext: mem_wb_out.pc4; 
  // ID/EX Connections. 
  assign id_ex_in.imemload = if_id_out.imemload; 
  assign id_ex_in.pc = if_id_out.pc; 
  assign id_ex_in.pc4 = if_id_out.pc4; 
  assign id_ex_in.rdat1 = rfif.rdat1; 
  assign id_ex_in.rdat2 = rfif.rdat2; 
  assign id_ex_in.rt = if_id_out.imemload[20:16]; 
  assign id_ex_in.rd = if_id_out.imemload[15:11]; 
  assign id_ex_in.halt = cuif.halt;
  assign id_ex_in.regsrc = cuif.regsrc; 
  assign id_ex_in.regdst = cuif.regdst; 
  assign id_ex_in.imm32 = imm32; 
  assign id_ex_in.regWEN = cuif.regWEN; 
  assign id_ex_in.dREN = cuif.dREN; 
  assign id_ex_in.dWEN = cuif.dWEN; 
  assign id_ex_in.alusrc = cuif.alusrc; 
  assign id_ex_in.aluop = cuif.aluop; 

  // EX stage. 
  // ALU input. 
  assign aluif.aluop = id_ex_out.aluop;  
  assign aluif.port_a = id_ex_out.rdat1; 
  assign aluif.port_b = (id_ex_out.alusrc == ALUSRC_REG) ? rfif.rdat2 : imm32; 

  // deciding baddr and jaddr. 
  assign ex_mem_in.jaddr = {id_ex_out.pc4[31:28], id_ex_out.imemload[25:0], 2'b0}; 
  assign ex_mem_in.baddr = id_ex_out.pc4 + (id_ex_out.imm32 << 2); 

  // lui ext. 
  assign ex_mem_in.lui_ext = (id_ex_out.regsrc == REGSRC_LUI) ? {id_ex_out.imemload[15:0], 16'b0} : word_t'(32'b0); 

  // decide regtbw. 
  assign ex_mem_in.regtbw = (id_ex_out.regdst == REGDST_RD) ? id_ex_out.imemload[15:11] : 
                            (id_ex_out.regdst == REGDST_RT) ? id_ex_out.imemload[20:16] : 
                            (id_ex_out.regdst == REGDST_RA) ? regbits_t'(5'd31) : regbits_t'(5'd0); 

  // EX/MEM latch connections. 
  assign ex_mem_in.imemload = id_ex_out.imemload; 
  assign ex_mem_in.pc = id_ex_out.pc; 
  assign ex_mem_in.pc4 = id_ex_out.pc4; 
  assign ex_mem_in.alu_out = aluif.port_o; 
  assign ex_mem_in.rdat1 = id_ex_out.rdat1; 
  assign ex_mem_in.rdat2 = id_ex_out.rdat2; 
  assign ex_mem_in.halt = id_ex_out.halt; 
  assign ex_mem_in.regsrc = id_ex_out.regsrc; 
  assign ex_mem_in.imm32 = id_ex_out.imm32; 
  assign ex_mem_in.regWEN = id_ex_out.regWEN; 
  assign ex_mem_in.dREN = id_ex_out.dREN; 
  assign ex_mem_in.dWEN = id_ex_out.dWEN; 
  assign ex_mem_in.zero = aluif.z; 

  // PC
  pcsrc_t pcsrc; 
  always_comb begin
    casez(opcode_t'(ex_mem_out.imemload[31:26]))
      HALT:     pcsrc = PCSRC_CPC; 
      JR:       pcsrc - PCSRC_REG; 
      JAL,J:    pcsrc = PCSRC_JAL; 
      BEQ:      pcsrc = (ex_mem_out.zero) ? PCSRC_IMM : PCSRC_PC4; 
      BNE:      pcsrc = (ex_mem_out.zero) ? PCSRC_PC4 : PCSRC_IMM; 
      default:  pcsrc = PCSRC_PC4; 
    endcase
  end

  always_comb begin : PC_MUX
    casez (pcsrc)
        PCSRC_CPC: mem_wb_in.npc = ex_mem_out.pc; 
        PCSRC_PC4: mem_wb_in.npc = ex_mem_out.pc4;
        PCSRC_REG: mem_wb_in.npc = ex_mem_out.rdat1; 
        PCSRC_JAL: mem_wb_in.npc = ex_mem_out.jaddr; 
        PCSRC_IMM: mem_wb_in.npc = ex_mem_out.baddr; 
      default: 
        mem_wb_in.npc = ex_mem_out.pc4; 
    endcase
    if (~dpif.ihit) begin
      npc = cpc;  // stall the increment on pc when instruction is not ready. 
    end
  end

  // MEM/WB latch connections. 
  assign mem_wb_in.imemload = ex_mem_out.imemload; 
  //assign mem_wb_in.dload = dpif.dmemload; 
  assign mem_wb_in.alu_out = ex_mem_out.alu_out; 
  assign mem_wb_in.lui_ext = ex_mem_out.lui_ext; 
  assign mem_wb_in.regtbw = ex_mem_out.regtbw; 
  assign mem_wb_in.halt = ex_mem_out.halt; 
  assign mem_wb_in.regsrc = ex_mem_out.regsrc; 
  assign mem_wb_in.regWEN = ex_mem_out.regWEN; 
  assign mem_wb_in.imm32 = ex_mem_out.imm32; 

  // input of request unit. EN 
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
      dpif.halt <= mem_wb_out.halt | dpif.halt; 
    end
  end

  cpu_tracker_if MW_o(); 
  


  // register file
  register_file rf(.CLK(CLK), .nRST(nRST), .rfif(rfif)); 
  // alu. 
  alu alu0 (.aluif(aluif)); 
  // control unit. 
  control_unit cu (cuif); 
  // request unit 
  request_unit ru (.CLK(CLK), .nRST(nRST), .ruif(ruif)); 

endmodule
