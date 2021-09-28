`include "cpu_types_pkg.vh"
`include "dp_types_pkg.vh"
`include "forwarding_if.vh"

import cpu_types_pkg::*;
import dp_types_pkg::*;

module forwarding (
  forwarding_if.fw fwif
);

  always_comb begin: FWD // Rs = [25:21] and Rt = [20:16] and Rd = [15:11]
    fwif.forwardA = '0;
    fwif.forwardB = '0;
    if (fwif.mem_wb_regWEN & (fwif.mem_wb_regtbw != '0) & (fwif.mem_wb_regtbw == fwif.rs)) begin
      fwif.forwardA = 2'b01;
    end
    if (fwif.mem_wb_regWEN & (fwif.mem_wb_regtbw != '0) & (fwif.mem_wb_regtbw == fwif.rt)) begin
      fwif.forwardB = 2'b01;
    end
    if (fwif.ex_mem_regWEN & (fwif.ex_mem_regtbw != '0) & (fwif.ex_mem_regtbw == fwif.rs)) begin
      fwif.forwardA = 2'b10;
    end
    if (fwif.ex_mem_regWEN & (fwif.ex_mem_regtbw != '0) & (fwif.ex_mem_regtbw == fwif.rt)) begin
      fwif.forwardB = 2'b10;
    end
  end

endmodule   
