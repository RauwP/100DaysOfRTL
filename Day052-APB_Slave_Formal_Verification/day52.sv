`include "prim_assert.sv"
`include "day17.sv"
module day52 (
  input         wire        clk,
  input         wire        reset,

  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        wire[31:0]  prdata_o,
  output        wire        pready_o
);

	logic apb_req;
	
	assign apb_req = psel_i & penable_i;
	
	day17 DAY17(
				.clk(clk),
				.reset(reset),
				.req_i(apb_req),
				.req_rnw_i(~pwrite_i),
				.req_addr_i(paddr_i),
				.req_wdata_i(pwdata_i),
				.req_ready_o(pready_o),
				.req_rdata_o(prdata_o)
				);
				
	`ifdef FORMAL
	
		//reset is one for one cycle at the start of the sim
		logic rst_one_cycle = 1'b0;
		always_ff @(posedge clk) begin
			rst_one_cycle <= 1'b1;
			assume (rst_one_cycle ^ reset);
		end
		
		logic asrt_psel_rose;
		always_ff @(posedge clk) asrt_psel_rose <= $rose(psel_i);
		
		`ASSUME_ZERO_IN_RESET(psel_i)
		`ASSUME_ZERO_IN_RESET(penable_i)
		
		`ASSUME(penable_chk, `IMPLIES($rose(penable_i), asrt_psel_rose))
		`ASSUME(psel_no_b2b, `IMPLIES($past(psel_i & penable_i & pready_o), ~psel_i))
		`ASSUME(penable_no_b2b, `IMPLIES($past(psel_i & penable_i & pready_o), ~penable_i))
		
		`ASSUME(psel_stable_setup, `IMPLIES($past(psel_i & ~penable_i), $stable(psel_i)))
		`ASSUME(psel_stable_acess, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(psel_i)))
		
		`ASSUME(penable_stable, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(penable_i)))
	
		`ASSUME(pwrite_stable, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(pwrite_i)))
		`ASSUME(pwdata_stable, `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(pwdata_i)))
		`ASSUME(paddr_stable,  `IMPLIES($past(psel_i & penable_i & ~pready_o), $stable(paddr_i)))

		//Add a failing check to view stimulus
		`ASSERT(asrt_fail, `IMPLIES(psel_i & penable_i & pready_o, pwdata_i == 32'hdead_cafe)) 

	`endif
endmodule
