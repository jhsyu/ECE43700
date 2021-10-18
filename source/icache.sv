`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module icache (
  input CLK, nRST,
  datapath_cache_if.icache icif
);

  logic ihit;
  assign icif.ihit = ihit;
  icachef_t instr_cache_address;
  assign instr_cache_address.tag = icif.imemaddr[31:6];
  assign instr_cache_address.idx = icif.imemaddr[5:2];
  assign instr_cache_address.bytoff = icif.imemaddr[1:0];
  icache_frame nxt_icache_frame;
  icache_frame instr_cache [15:0];

  always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
      for (int i = 0; i < 16; i++) begin
	instr_cache[i] <= {1'b0, 26'b0, word_t'(0)};
      end
    end
    else begin
       instr_cache[instr_cache_address.idx] <= nxt_icache_frame;
    end
  end
   
  // inputs:  imemREN, imemaddr
  // outputs: ihit, imemload

  always_comb begin
    if ( (instr_cache[instr_cache_address.idx].tag == instr_cache_address.tag) && (instr_cache[instr_cache_address].valid) ) begin
      ihit = 1'b1;
    end
    else begin
      ihit = 1'b0;
    end
  end
  
endmodule
