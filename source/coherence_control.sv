`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*; 

typedef enum logic[4:0] {
    IDLE, INV,  
    SNP1, SNP2, SNP3,		// broadcast the data request and wait for response. 
    WB1, WB2, WB3,			// M->I, no forward, just update memory. 
    LD1, LD2, LD3, LD4,		// also miss in another cache. load from memory.
    IRD,                        // miss in the icache. load from memory. (no need for forwarding)
    FWDWB1, FWDWB2, FWDWB3, FWDWB4, FWDWB5, // M->S, the data comes from another cache. 
    FWD1, FWD2, FWD3, FWD4	// busrd, supply data from other cache to this. 
} cc_state_t;

/*
Cases: 
	ID			0			1
	s		  I->S		   S/I 			SNP->LD			P1 no change, SNP-> LD
	s		  I->S		   M->S			SNP->FWDWB		data comes from another cache. UPDATE MEM		
	
	s		  I->M		    I			SNP->LD			write miss, data load from memory. 
	s 		I->(S->)M	M->(S->)I		SNP->FWD (INV)	write miss, invalidate P1, no need to update MEM.
	s		I->(S->)M	S->(S->)I		SNP->LD  (INV)	no cctrans when s->s. load from MEM
	s 		  S->M			I			IDLE			write hit, dWEN not asserted. no change on P1.
	s		  S->M		   S->I			INV				write hit on P0, invalidate P1.
	s		  M->I			-			WB				entry get evicted. 
*/

module coherence_control (
	input logic CLK, nRST, 
	cache_control_if ccif
);
	cc_state_t s, nxt_s; 
	logic prid, nxt_prid; 

	word_t [1 : 0] iaddr, daddr, dstore; 
	ramstate_t ramstate; 
	// latch the signals potentially change during the cycle. 
	always_ff @(posedge CLK) begin
		daddr <= ccif.daddr;
	        iaddr <= ccif.iaddr; 
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
	        ccif.iwait = '1; 
		ccif.dload = '0; 
	        ccif.iload = '0; 
		ccif.ramstore = '0; 
		ccif.ramaddr = '0; 
		ccif.ramWEN = '0; 
		ccif.ramREN = '0; 
		ccif.ccwait = '0; 
		ccif.ccinv = '0; 
		casez (s)
			IDLE: begin
				// nxt_prid = ccif.cctrans[~prid] ? ~prid : prid; 
			        // if both processors assert at the same time, toggle prid
			        if ((ccif.dREN[0] && ccif.dREN[1]) || (ccif.dWEN[0] && ccif.dWEN[1]) || (ccif.iREN[0] && ccif.iREN[1])) begin
				        nxt_prid = prid ^ 1'b1;
				end
			        else begin
				        nxt_prid = ccif.cctrans[~prid] ? ~prid : prid;
				end  
				// check the reason of cctrans. 
				if (ccif.cctrans[nxt_prid] && ccif.dREN[nxt_prid]) begin
					nxt_s = SNP1; 
				end
				else if (ccif.cctrans[nxt_prid] && ccif.dWEN[nxt_prid]) begin
					nxt_s = WB1;
				end
			        else if (ccif.cctrans[nxt_prid] && ccif.iREN[nxt_prid]) begin
				        nxt_s = IRD;
				end
				else if (ccif.cctrans[nxt_prid]) begin
					nxt_s = INV; 
				end
				else begin
					nxt_s = IDLE; 
				end
			end
			SNP1: begin
				ccif.ccwait[~prid] = 1'b1; 
				ccif.ccinv[~prid] = ccif.ccwrite[prid]; // invalidation happens only when write.
				nxt_s = SNP2; 
			end
			SNP2: begin
				// wait for other cache to reesponse. 
				ccif.ccwait[~prid] = 1'b1; 
				ccif.ccinv[~prid] = ccif.ccwrite[prid];
				nxt_s = SNP3; 
			end
			SNP3: begin
				ccif.ccwait[~prid] = 1'b1; 
				ccif.ccinv[~prid] = ccif.ccwrite[prid]; 
				if (ccif.cctrans[~prid] && ccif.ccwrite[prid]) nxt_s = FWD1; // if write no need to modify mem. 
				else if (ccif.cctrans[~prid] && ~ccif.ccwrite[prid]) nxt_s = FWDWB1;
				else nxt_s = LD1; 
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
				ccif.ccinv[~prid] = 1'b1; 
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
				ccif.ramaddr = daddr[~prid]; 
				ccif.ramWEN = 1'b1; 
				ccif.dwait[~prid] = ~(ccif.ramstate == ACCESS); 
				nxt_s = (ccif.ramstate == ACCESS) ? FWDWB3 : FWDWB2; 
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
				ccif.ramaddr = daddr[~prid]; 
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

		        IRD: begin
				ccif.ramaddr = iaddr[prid]; 
				ccif.ramREN = 1'b1;
				ccif.iload[prid] = ccif.ramload; 
				ccif.iwait[prid] = (ccif.ramstate == ACCESS);  
				nxt_s = (ccif.ramstate == ACCESS) ? IDLE : IRD;
			end
		endcase
	end
endmodule
