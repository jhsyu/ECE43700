`ifndef CACHES_TYPES_PKG_VH
`define CACHES_TYPES_PKG_VH
`include "cpu_types_pkg.vh"


package caches_types_pkg;
    import cpu_types_pkg::*;

    typedef enum logic[3:0] {  
      IDLE, ALLOC0, ALLOC1, WB0, WB1, FLUSH0, FLUSH1, COUNT, CLEAN, FWD0, FWD1, INV  
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
