`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

typedef enum logic[4:0] {
    IDLE, INV,  
    SNP1, SNP2, SNP3,		// broadcast the data request and wait for response. 
    WB1, WB2, WB3,			// M->I, no forward, just update memory. 
    LD1, LD2, LD3, LD4,		// also miss in another cache. load from memory. 
    FWDWB1, FWDWB2, FWDWB3, FWDWB4, FWDWB5, // M->S, the data comes from another cache. 
    FWD1, FWD2, FWD3, FWD4	// busrd, supply data from other cache to this. 
} cc_state_t;

module coherence_control (
	input logic CLK, nRST, 
	cache_control_if ccif
);
	cc_state_t s, nxt_s; 
	logic prid, nxt_prid; 

	word_t [CPU-1 : 0] daddr, dstore; 
	ramstate_t ramstate; 
	// latch the signals potentially change during the cycle. 
	always_ff @(posedge CLK) begin
		daddr <= ccif.daddr; 
		dstore <= ccif.dstore; 
		ramstate <= ccif.ramstate;
	end

	always_ff @(posedge CLK, negedge nRST) begin
		if (~nRST) begin
			prid <= 0; 
			s <= IDLE; 
		end
		else begin
			prid <= nxt_prid; 
			s <= nxt_s; 
		end
	end
	assign ccif.ccsnoopaddr = {daddr[1], daddr[0]}; 
	always_comb begin
		nxt_prid = prid; 
		// prid is the id of the processor we are serving now. 
		nxt_s = s; 
		// output
		ccif.dwait = '1; 
		ccif.dload = '0;
		ccif.ramstore = '0; 
		ccif.ramaddr = '0; 
		ccif.ramWEN = '0; 
		ccif.ramREN = '0; 
		ccif.ccwait = '0; 
		ccif.ccinv = '0; 
		casez (s)
			IDLE: begin
				nxt_prid = ccif.cctrans[~prid] ? ~prid : prid;  
				// check the reason of cctrans. 
				if (ccif.cctrans[nxt_prid] && ccif.dREN[nxt_prid]) begin
					// this is a prRd. 
					// but still need to deal with write, because we allocate first.
					// every write miss is a read miss as well. 
					// ID	nxt_prid ~nxt_prid
					// 	s	  I->S	   M->S		(FWDWB)
					//	s	  I->M	   S,M->I 	(FWD)
					//	s	  I->S	   S, I		(LOAD)
					nxt_s = SNP1; 
				end
				else if (ccif.cctrans[nxt_prid] && ccif.dWEN[nxt_prid]) begin
					// prWr	(invaliddation of id=1 will be finished in next serve cycle. )
					// ID	nxt_prid ~nxt_prid
					//	s	  I->M	   S->I		(WB)
					// 	s	  I->M	   M->I		(WB)
					//	s	  S->M	   S->I		(WB) cache transfer not nessary, but wb needed.
					//  s     I->M	    I		(WB, no INV. )
					//  s     S->M	    I		(WB, no INV. )
					nxt_s = WB1;
				end
				else if(cctrans[nxt_prid]) begin
					// ID	nxt_prid ~nxt_prid
					// 	s	  I->M	   M->I		(WB, INV)
					//	s	  I->M	   S->I		(WB, INV)
					//	s	  S->M	   S->I		(WB, INV) 
					mxt_s = INV1; 
				end
				else begin
					// ID	nxt_prid ~nxt_prid
					// 	s	  M->M	   	I		(HIT)
					//	s	  S->S	   	-		(HIT)
					//  S	  M->S		I		(cache write back.)
					nxt_s = IDLE; 
				end
			end 
			SNP1: begin
				ccif.ccwait[~prid] = 1'b1; 
				nxt_s = SNP2; 
			end
			SNP2: begin
				// wait for other cache to reesponse. 
				ccif.ccwait[~prid] = 1'b1; 
				nxt_s = SNP3; 
			end
			SNP3: begin
				ccif.ccwait[~prid] = 1'b1; 
				if (cctrans[~prid] && ccif.ccwrite[prid]) nxt_s = FWD1; // if write no need to modify mem. 
				else if (cctrans[~prid] && ~ccif.ccwrite[prid]) nxt_s = FWDWB1;
				else nxt_s = LOAD1; //[~prid]: S or I
			end
			WB1: begin
				ccif.ramWEN = 1'b1; 
				ccif.ramaddr = daddr[prid]; 
				ccif.ramstore = dstore[prid]; 
				ccif.dwait = ~(ccif.ramstate == ACCESS); 
				nxt_s = (ccif.ramstate == ACCESS) ? WB2 : WB1; 
			end
			WB2: begin
				// wait for cache assign 2 nd word. 
				ccif.ramWEN = 1'b0; 
				nxt_s = WB3; 
			end
			WB3: begin
				ccif.ramWEN = 1'b1; 
				ccif.ramaddr = daddr[prid]; 
				ccif.ramstore = dstore[prid]; 
				ccif.dwait = ~(ccif.ramstate == ACCESS); 
				nxt_s = (ccif.ramstate == ACCESS) ? IDLE : WB3; 
			end
			INV: begin
				// invalidate copy in [~nxt_prid]
				ccif.inv[~prid] = 1'b1; 
				ccif.dwait[prid] = 1'b1; 
				nxt_s = IDLE; 
			end

			FWD1: begin
				nxt_s = FWD2; 
				ccif.dload[prid] = dstore[~prid]; 
				ccif.dwait[prid] = 1'b0; 
				ccif.dwait[~prid] = 1'b0; 
			end

			FWD2: begin
				nxt_s = FWD3; 
				ccif.dwait = '1; 
			end

			FWD3: begin
				nxt_s = IDLE; 
				ccif.dload[prid] = dstore[~prid]; 
				ccif.dwait[prid] = 1'b0; 
				ccif.dwait[~prid] = 1'b0; 
			end

			FWDWB1: begin
				ccif.dload[prid] = dstore[~prid]; 
				ccif.dwait[prid] = 1'b0; 
				nxt_s = FWDWB2; 
			end
			FWDWB2: begin
				ccif.ramstore = dstore[~prid]; 
				ccif.daddr = daddr[~prid]; 
				ccif.ramWEN = 1'b1; 
				ccif.dwait[~prid] = ~(ccif.ramstate == ACCESS); 
				nxt_s = (ccif.ramstate == ACCESS) ? FWDWB2 : FWDWB1; 
			end
			FWDWB3: begin
				// wait for [~prid] assign 2nd word. 
				nxt_s = FWDWB4; 
				ccif.dwait = '1; 
			end
			FWDWB4: begin
				ccif.dload[prid] = dstore[~prid]; 
				ccif.dwait[prid] = 1'b0; 
				nxt_s = FWDWB5; 
			end
			FWDWB5: begin
				ccif.ramstore = dstore[~prid]; 
				ccif.daddr = daddr[~prid]; 
				ccif.ramWEN = 1'b1; 
				ccif.dwait[~prid] = ~(ccif.ramstate == ACCESS); 
				nxt_s = (ccif.ramstate == ACCESS) ? IDLE : FWDWB5; 
			end

			LD1: begin
				ccif.ccwait[~prid] = 1'b1;
				ccif.ramaddr = daddr[prid]; 
				ccif.ramREN = 1'b1;
				ccif.dload[prid] = ccif.ramload; 
				ccif.dwait[prid] = (ccif.ramstate == ACCESS);  
				nxt_s = (ccif.ramstate == ACCESS) ? LD2 : LD1;
			end

			LD2: begin
				ccif.ramREN = 1'b0; 
				nxt_s = LD3; 
			end

			LD3: begin
				ccif.ccwait[~prid] = 1'b1;
				ccif.ramaddr = daddr[prid]; 
				ccif.ramREN = 1'b1;
				ccif.dload[prid] = ccif.ramload; 
				ccif.dwait[prid] = (ccif.ramstate == ACCESS);  
				nxt_s = (ccif.ramstate == ACCESS) ? IDLE : LD3;
			end
		endcase
	end


	
endmodule