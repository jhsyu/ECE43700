`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"
`include "caches_types_pkg.vh"

import cpu_types_pkg::*;
import caches_types_pkg::*;

module dcache_tb;

    parameter PERIOD = 10;
    logic clk = 0, nRST;

    always #(PERIOD/2) clk++;

    caches_if cif ();
    datapath_cache_if dcif ();
    // test program setup
    test PROG ();

    dcache DUT(clk, nRST, dcif, cif);

endmodule

program test;

    import cpu_types_pkg::*;

    integer test_case_num = 0;
    string test_case_info = "NULL"; 
    parameter PERIOD = 10;
    
    task check_dhit(input logic expected_dhit);
        #(1); 
        assert (dcif.dhit == expected_dhit) $display("testcase %0d pass", test_case_num); 
            else $display("testcase %0d: incorrect dhit", test_case_num);
    endtask
    task reset_DUT;
        dcache_tb.nRST = 1;
        dcache_tb.dcif.halt = 0;
        dcache_tb.dcif.dmemREN = 0;
        dcache_tb.dcif.dmemWEN = 0;
        dcache_tb.dcif.datomic = 0;
        dcache_tb.dcif.dmemstore = 0;
        dcache_tb.dcif.dmemaddr = 0;
        dcache_tb.cif.dwait = 1;
        dcache_tb.cif.dload = 0;
        dcache_tb.cif.ccwait = 0;
        dcache_tb.cif.ccinv = 0;
        dcache_tb.cif.ccsnoopaddr = 0;
        // reset
        dcache_tb.nRST = 0;
        #(PERIOD * 2);
        dcache_tb.nRST = 1;
    endtask
    
    initial begin
        reset_DUT();
        test_case_num ++; 
        test_case_info = "testcase 1: compulsory miss"; 
        //load from 0x80, MISS
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemREN = 1;
        dcache_tb.dcif.dmemaddr = {26'h80, 3'h0, 1'b0, 2'b00};
        check_dhit(1'b0); 
        wait(dcache_tb.cif.dREN | dcache_tb.cif.dWEN);
        @(negedge dcache_tb.clk); 
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h1;
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemaddr = {26'h80, 3'h0, 1'b1, 2'b00};
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h2;
        #(PERIOD);

        //load from 0x81, HIT
        test_case_num ++; 
        test_case_info = "testcase 2: hit after conpulsory miss"; 
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemREN = 1;
        dcache_tb.dcif.dmemaddr = {26'h80, 3'h0, 1'b1, 2'b00};
        check_dhit(1'b1); 

        //save to 0x80, HIT. 
        test_case_info = "testcase 3: writing to cache"; 
        test_case_num++;
        @(negedge dcache_tb.clk); 
        dcache_tb.cif.dwait = 1;
        dcache_tb.dcif.dmemREN = 0;
        dcache_tb.dcif.dmemWEN = 1;
        dcache_tb.dcif.dmemaddr = {26'h80, 3'h0, 1'b0, 2'b00};
        dcache_tb.dcif.dmemstore = 32'h3;
        check_dhit(1'b1);
        #(PERIOD);

        // load from 0x180, MISS
        test_case_num ++; 
        test_case_info = "testcase 4: conpulsory miss (frame[1])"; 
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemWEN = 0;
        dcache_tb.dcif.dmemREN = 1;
        dcache_tb.dcif.dmemaddr = {26'h180, 3'h0, 1'b0, 2'b00};
        check_dhit(1'b0); 

        wait(dcache_tb.cif.dREN | dcache_tb.cif.dWEN);
        @(negedge dcache_tb.clk); 
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h4;
        
        wait(dcache_tb.cif.dREN | dcache_tb.cif.dWEN);
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemaddr = {26'h180, 3'h0, 1'b1, 2'b00};
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h5;
        
        #(PERIOD);


        // load from 0x280, MISS / check replacement wirte back
        test_case_num ++; 
        test_case_info = "testcase 4: conflict miss"; 
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemWEN = 0;
        dcache_tb.dcif.dmemREN = 1;
        dcache_tb.dcif.dmemaddr = {26'h280, 3'h0, 1'b0, 2'b00};
        check_dhit(1'b0); 
        dcache_tb.cif.dwait = 0;

        wait(dcache_tb.cif.dREN);
        @(negedge dcache_tb.clk); 
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h6;

        wait(dcache_tb.cif.dREN);
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemaddr = {26'h280, 3'h0, 1'b1, 2'b00};
        dcache_tb.cif.dwait = 0;
        dcache_tb.cif.dload = 32'h7;
        wait(dcif.dhit);
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemWEN = 0;
        dcache_tb.dcif.dmemREN = 0;
        
        
        test_case_info = "testcase 5: writing to cache"; 
        test_case_num++;
        @(negedge dcache_tb.clk); 
        dcache_tb.cif.dwait = 1;
        dcache_tb.dcif.dmemREN = 0;
        dcache_tb.dcif.dmemWEN = 1;
        dcache_tb.dcif.dmemaddr = {26'h280, 3'h0, 1'b1, 2'b00};
        dcache_tb.dcif.dmemstore = 32'h8888;
        check_dhit(1'b1);
        @(negedge dcache_tb.clk); 
        dcache_tb.dcif.dmemWEN = 0;
        dcache_tb.dcif.dmemREN = 0;
        
        //check hit counter = 3
        #(PERIOD);
        #(PERIOD);

        // HALT check all frames invalid; dirty frames write back
        test_case_num ++; 
        test_case_info = "testcase 6: halt and writeback"; 
        dcache_tb.dcif.halt = 1;
        dcache_tb.cif.dwait = 0;
        #(PERIOD * 32);

        //Write back hit counter
        #(PERIOD * 2);
        dcache_tb.cif.dwait = 1;

        //check flushed
        #(PERIOD * 8);
    end
endprogram