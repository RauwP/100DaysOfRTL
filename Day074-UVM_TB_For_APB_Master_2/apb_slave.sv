//APB Slave

module day18(
	input		wire 		clk,
	input		wire 		reset,
	
	input		wire		psel_i,
	input		wire		penable_i,
	input		wire[9:0] 	paddr_i,
	input		wire		pwrite_i,
	input		wire[31:0]	pwdata_i,

	output		wire[31:0]	prdata_o,
	output		wire		pready_o
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

endmodule

module day17(
	input		wire		clk,
	input		wire		reset,

	input		wire		req_i,
	input		wire		req_rnw_i,
	input		wire[9:0]	req_addr_i,
	input		wire[31:0]	req_wdata_i,
	
	output		wire		req_ready_o,
	output		wire[31:0]	req_rdata_o
);

logic [1023:0][31:0] mem;

logic mem_rd, mem_wr, req_rising_edge;

logic [3:0] lfsr_val, cnt, cnt_ff, nxt_cnt;

assign mem_rd = req_i & req_rnw_i;
assign mem_wr = req_i & ~req_rnw_i;

day3 DAY3(.clk(clk), .reset(reset), .a_i(req_i), .rising_edge_o(req_rising_edge), .falling_edge_o());

always_ff @(posedge clk or posedge reset)
	if(reset)
		cnt_ff <= 4'h0;
	else
		cnt_ff <= nxt_cnt;

assign nxt_cnt = req_rising_edge ? lfsr_val : cnt_ff + 4'h1;

assign cnt = cnt_ff;

day7 DAY7(.clk(clk), .reset(reset), .lfsr_o(lfsr_val));

always_ff @(posedge clk)//write to mem when the counter = 0 and there is a wr request
	if(mem_wr & ~|cnt) mem[req_addr_i]<= req_wdata_i;

assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};

assign req_ready_o = ~|cnt;

endmodule

module day3(
	input		wire		clk,
	input		wire		reset,

	input		wire		a_i,

	output		wire		rising_edge_o,
	output		wire		falling_edge_o
);

logic a_ff;

always_ff @(posedge clk or posedge reset)
	if(reset)
		a_ff <= 1'b0;
	else
		a_ff <= a_i;

assign rising_edge_o = a_i & ~a_ff;
assign falling_edge_o = ~a_i & a_ff;

endmodule

module day7(
	input		wire		clk,
	input		wire		reset,

	output		wire[3:0]	lfsr_o
);

logic[3:0] lfsr_ff, lfsr_nxt;

always_ff @(posedge clk or posedge reset)
	if(reset)
		lfsr_ff <= 4'hE;
	else
		lfsr_ff <= lfsr_nxt;

assign lfsr_nxt = {lfsr_ff[2:0], lfsr_ff[1]^lfsr_ff[3]};

assign lfsr_o = lfsr_ff;

endmodule