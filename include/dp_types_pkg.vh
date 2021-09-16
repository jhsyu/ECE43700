`ifndef DP_TYPES_PKG_VH
`define DP_TYPES_PKG_VH

package dp_types_pkg; 
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
        PCSRC_NPC = 3'h1,           // PC + 4
        PCSRC_REG = 3'h2,           // jr
        PCSRC_JAL = 3'h3,           // imm26
        PCSRC_IMM = 3'h4            // branch
    } pcsrc_t; 

    typedef enum logic {
        ALUSRC_REG = 1'b0, 
        ALUSRC_IMM = 1'b1          // imm32, ext
    } alusrc_t; 
endpackage
`endif