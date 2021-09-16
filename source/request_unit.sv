`include "request_unit_if.vh"
module request_unit(
    input CLK, nRST,
    request_unit_if.ru ruif
);

    assign ruif.imemREN = 1;

    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            ruif.dmemREN <= 0;
            ruif.dmemWEN <= 0;
        end
        else begin
            ruif.dmemREN <= ~ruif.dhit & (ruif.dmemREN | ruif.dREN);
            ruif.dmemWEN <= ~ruif.dhit & (ruif.dmemWEN | ruif.dWEN);
        end  
    end
endmodule
