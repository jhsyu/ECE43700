`ifndef CACHES_TYPES_PKG_VH
`define CACHES_TYPES_PKG_VH
`include "cpu_types_pkg.vh"


package caches_types_pkg;
    import cpu_types_pkg::*;

    typedef enum logic[2:0] {  
      IDLE  = 3'd0, 
      DHIT  = 3'd1, 
      ALLOC = 3'd2, 
      WB0   = 3'd3, 
      WB1   = 3'd4, 
      HALT  = 3'd5, 
      DUMP, = 3'd6,  
      CLEAN = 3'd7 
    } dcache_state_t;

    typedef struct packed {
        logic lru_id; 
        dcache_frame [1:0] frame, 
    } dcache_line_t;

   

endpackage
`endif
