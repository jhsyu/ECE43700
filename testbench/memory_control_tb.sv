// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
`include "system_if.vh"
import cpu_types_pkg::*; 

`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;
  always #(PERIOD/2) CLK++;

  caches_if cif0();
  caches_if cif1();
  cache_control_if #(.CPUS(1)) ccif(cif0, cif1);
  cpu_ram_if prif();
  system_if syif();

  string test_case_info;


  assign prif.ramREN = syif.tbCTRL ? syif.REN : ccif.ramREN;
  assign prif.ramWEN = syif.tbCTRL ? syif.WEN : ccif.ramWEN;
  assign prif.ramaddr = syif.tbCTRL ? syif.addr : ccif.ramaddr;
  assign prif.ramstore = syif.tbCTRL ? syif.store : ccif.ramstore;
  assign syif.load = prif.ramload;
  assign ccif.ramload = prif.ramload;
  assign ccif.ramstate = prif.ramstate;
  
  
  // DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
  ram #(.LAT(0)) ram_tb(CLK, nRST, prif);
`endif

  test mytest(CLK, nRST, ccif, prif, syif);


  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    syif.tbCTRL = 1;
    syif.addr = 0;
    syif.WEN = 0;
    syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      syif.addr = i << 2;
      syif.REN = 1;
      repeat (4) @(posedge CLK);
      if (syif.load === 0)
        continue;
      values = {8'h04,16'(i),8'h00,syif.load};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      syif.tbCTRL = 0;
      syif.REN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask


  program test (input CLK, output logic nRST, cache_control_if ccif, 
                cpu_ram_if prif, system_if.tb syif);
    parameter PERIOD = 10;
    initial begin
      test_case_info = "Resetting";
      $display("Resetting");
      syif.tbCTRL = 0;
      syif.addr = 0;
      syif.WEN = 0;
      syif.REN = 0;

      ccif.cif0.iREN = 0;
      ccif.cif0.dREN = 0;
      ccif.cif0.dWEN = 0;
      ccif.cif0.dstore = 0;
      ccif.cif0.iaddr = 0;
      ccif.cif0.daddr = 0;

      nRST = 0;
      repeat (2) @(negedge CLK);
      nRST = 1;
      $display("Reset done");
      
      test_case_info = "instruction_read_only";
      for (int i = 0; i < 5; i++) begin
        @(posedge CLK);
        ccif.cif0.iREN = 1;
        ccif.cif0.iaddr = i << 2;
        wait(~ccif.iwait);
        @(posedge CLK);
      end

      @(posedge CLK);
      ccif.cif0.iREN = 0; 
    
      test_case_info = "data_read_only";
      for (int i = 0; i < 5; i++) begin
        @(posedge CLK);
        ccif.cif0.dREN = 1;
        ccif.cif0.daddr = i << 2;
        wait(~ccif.dwait);
        @(posedge CLK);
        // @(posedge CLK);
        // ccif.cif0.dREN = 0;   
      end
      @(posedge CLK);
      ccif.cif0.dREN = 0; 


      test_case_info = "data_and_instruction_read";
      for (int i = 0; i < 5; i++) begin
        @(posedge CLK);
        ccif.cif0.dREN = 1;
        ccif.cif0.iREN = 1;
        ccif.cif0.daddr = i << 2;
        ccif.cif0.iaddr = (i+1) << 2;
        wait(~ccif.dwait);
        @(posedge CLK);
        ccif.cif0.dREN = 0; 
        wait(~ccif.iwait);
        @(posedge CLK);
      end
      @(posedge CLK);
      ccif.cif0.iREN = 0;
      
      test_case_info = "data_write_only";
      for (int i = 0; i < 5; i++) begin
        @(posedge CLK);
        ccif.cif0.dWEN = 1;
        ccif.cif0.daddr = (32+i) << 2;
        ccif.cif0.dstore = word_t'{i};
        wait(~ccif.dwait);
        @(posedge CLK);
      end
      @(posedge CLK);
      ccif.cif0.dWEN = 0;

      test_case_info = "data_write_instruction_read";
      for (int i = 5; i < 10; i++) begin
        @(posedge CLK);
        ccif.cif0.dWEN = 1;
        ccif.cif0.daddr = (32+i) << 2;
        ccif.cif0.dstore = word_t'{i};

        ccif.cif0.iREN = 1;
        ccif.cif0.iaddr = (i+1) << 2;
        wait(~ccif.dwait);
        @(posedge CLK);
        ccif.cif0.dWEN = 0;
        wait(~ccif.iwait);
        @(posedge CLK);
      end
      @(posedge CLK);
      ccif.cif0.dWEN = 0;

      // $display("Test ends. Dumping memory.");
      test_case_info = "Dumping memory";
      memory_control_tb.dump_memory();

      test_case_info = "DONE";
      #(2 * PERIOD);
      $display("Finish");
    end

  endprogram
endmodule