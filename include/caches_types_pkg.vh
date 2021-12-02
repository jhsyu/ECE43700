`ifndef CACHES_TYPES_PKG_VH
`define CACHES_TYPES_PKG_VH
`include "cpu_types_pkg.vh"


package caches_types_pkg;
    import cpu_types_pkg::*;

    typedef enum logic[3:0] {  
      DC_IDLE, 
      DC_ALLOC0, 
      DC_ALLOC1, 
      DC_WB0, 
      DC_WB1, 
      DC_FLUSH0, 
      DC_FLUSH1, 
      DC_COUNT, 
      DC_CLEAN, 
      DC_FWD0, 
      DC_FWD1, 
      DC_INV  
    } dcache_state_t;

    typedef struct packed {
        logic lru_id; 
        dcache_frame [1:0] frame; 
    } dcache_line_t;

    typedef enum logic {
      IC_IDLE, IC_MISS
    } icache_state_t;
endpackage
`endif
