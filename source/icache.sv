`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module icache (
  input logic CLK, input logic nRST,
  datapath_cache_if.icache icif,
  caches_if.icache cif
);

  logic ihit;
  icachef_t instr_cache_address;
  assign instr_cache_address.tag = icif.imemaddr[31:6];
  assign instr_cache_address.idx = icif.imemaddr[5:2];
  assign instr_cache_address.bytoff = icif.imemaddr[1:0];
  icache_frame nxt_icache_frame;
  icache_frame instr_cache [15:0];

  always_ff @(posedge CLK, negedge nRST) begin
    if (~nRST) begin
      icif.ihit <= 1'b0;
      for (int i = 0; i < 16; i++) begin
	instr_cache[i] <= {1'b0, 26'b0, word_t'(0)};
      end
    end
    else begin
      icif.ihit <= ihit;
      instr_cache[instr_cache_address.idx] <= nxt_icache_frame;
    end
  end

  assign icif.imemload = instr_cache[instr_cache_address.idx].data; 

  always_comb begin
    if (icif.imemREN == 1'b1) begin
      if ( (instr_cache[instr_cache_address.idx].tag == instr_cache_address.tag) && (instr_cache[instr_cache_address.idx].valid) ) begin
        cif.iaddr = word_t'(0);
        cif.iREN = 1'b0;
        ihit = 1'b1;
        nxt_icache_frame = instr_cache[instr_cache_address.idx];
      end
      else begin
        cif.iaddr = icif.imemaddr;
        cif.iREN = 1'b1;
        if (cif.iwait == 1'b0) begin
  	  nxt_icache_frame = {1'b1, instr_cache_address.tag, cif.iload};
	  ihit = 1'b1; 
        end
        else begin
	  nxt_icache_frame = instr_cache[instr_cache_address.idx];
	  ihit = 1'b0; 
        end
      end
    end
    else begin
      cif.iaddr = word_t'(0);
      cif.iREN = 1'b0;
      ihit = 1'b0;
      nxt_icache_frame = instr_cache[instr_cache_address.idx];
    end
  end
  
endmodule
