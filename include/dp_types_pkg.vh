`ifndef DP_TYPES_PKG_VH
`define DP_TYPES_PKG_VH
`include "cpu_types_pkg.vh"


package dp_types_pkg;
    import cpu_types_pkg::*;
   
    typedef enum logic [1:0] {
        REGSRC_ALU = 2'h0, 
        REGSRC_MEM = 2'h1, 
        REGSRC_LUI = 2'h2,     
        REGSRC_NPC = 2'h3
    } regsrc_t;

    typedef enum logic [1:0] {
        REGDST_RD = 2'h0, 
        REGDST_RT = 2'h1, 
        REGDST_RA = 2'h2           // for JAL. 
    } regdst_t; 

    typedef enum logic {
        ZERO_EXT = 1'b0, 
        SIGN_EXT = 1'b1
    } extsel_t; 

    typedef enum logic [2:0] {
        PCSRC_CPC = 3'h0,           // PC, for halt
        PCSRC_PC4 = 3'h1,           // PC + 4
        PCSRC_REG = 3'h2,           // jr
        PCSRC_JAL = 3'h3,           // imm26
        PCSRC_IMM = 3'h4            // branch
    } pcsrc_t; 

    typedef enum logic {
        ALUSRC_REG = 1'b0, 
        ALUSRC_IMM = 1'b1          // imm32, ext
    } alusrc_t;

    typedef struct packed {
       word_t imemload;
       word_t pc, pc4;
    } IF_ID_t;
   
    typedef struct packed {
       word_t imemload;
       word_t pc, pc4;
       word_t rdat1, rdat2;
       regbits_t rt, rd;
       logic halt;
       regsrc_t regsrc;
       regdst_t regdst;
       word_t imm32;
       word_t lui_ext; 
       logic regWEN;
       logic dREN, dWEN;
       alusrc_t alusrc;
       aluop_t aluop;
    } ID_EX_t;

    typedef struct packed {
       word_t imemload;
       word_t pc, pc4;
       word_t alu_out, rdat1, rdat2;
       word_t lui_ext, baddr, jaddr;
       regbits_t regtbw;
       logic halt;
       regsrc_t regsrc;
       word_t imm32;
       logic regWEN;
       logic dREN, dWEN;
       logic zero;
    } EX_MEM_t;

    typedef struct packed {
       word_t imemload;
       word_t dload, alu_out;
       word_t lui_ext;
       regbits_t regtbw;
       logic halt;
       regsrc_t regsrc;
       logic regWEN;
       word_t imm32;
    } MEM_WB_t;

    // new memory typedef
    typedef struct packed {
       word_t dload;
    } MEM_WB_DATA_t;

endpackage
`endif
