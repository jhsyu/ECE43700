`ifndef CACHES_TYPES_PKG_VH
`define CACHES_TYPES_PKG_VH
`include "cpu_types_pkg.vh"


package caches_types_pkg;
    import cpu_types_pkg::*;

    typedef enum logic[3:0] {  
      IDLE, ALLOC0, ALLOC1, WB0, WB1, DUMP, COUNT, CLEAN, ERROR  
    } dcache_state_t;

    typedef struct packed {
        logic lru_id; 
        dcache_frame [1:0] frame; 
    } dcache_line_t;

endpackage
`endif
