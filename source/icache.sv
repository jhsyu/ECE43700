`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module icache (
  input CLK, nRST,
  datapath_cache_if.icache icif,
  caches_if.icache cif
);

  logic ihit;
  assign icif.ihit = ihit;
  ramstate_t istate;
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

  always_comb begin
    if ( (instr_cache[instr_cache_address.idx].tag == instr_cache_address.tag) && (instr_cache[instr_cache_address].valid) ) begin
      cif.iaddr = word_t'(0);
      cif.iREN = 1'b0;
      ihit = 1'b1;
      nxt_icache_frame = instr_cache[instr_cache_address.idx]; 
    end
    else begin
      cif.iaddr = icif.imemaddr;
      cif.iREN = 1'b1;
      ihit = 1'b0;
      if (cif.iwait == 1'b0) begin
	nxt_icache_frame = {1'b1, instr_cache[instr_cache_address.idx].tag, cif.iload};
      end
      else begin
	nxt_icache_frame = instr_cache[instr_cache_address.idx]; 
      end
    end
  end
  
endmodule
