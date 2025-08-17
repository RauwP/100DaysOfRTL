//apb master

module apb_master(
	input		wire		clk,
	input		wire		reset,
	
	output		wire		psel_o,
	output		wire		penable_o,
	output		wire[31:0]	paddr_o,
	output		wire		pwrite_o,
	output		wire[31:0]	pwdata_o,
	input		wire		pready_i,
	input		wire[31:0]	prdaya_i
);

typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

apb_state_t nxt_state, curr_state;

logic[31:0] rdata_q;

logic[3:0] curr_cnt, nxt_cnt, lfsr_val, cnt;

always_ff @(posedge clk or posedge reset) begin
	if(reset)
		curr_cnt <=4'hF;
	else
		curr_cnt <= nxt_cnt;
end

assign nxt_cnt = pready_i ? lfsr_val : curr_cnt - 4'h1;

assign cnt = curr_cnt;

day7 DAY7(.clk(clk), .reset(reset), .lfsr_o(lfsr_val));

always_ff @(posedge clk or posedge reset) begin
	if (reset)
		curr_state <= ST_IDLE;
	else
		curr_state <= nxt_state;
end

always_comb begin
	nxt_state = curr_state;

	case (curr_state)
		ST_IDLE: if(curr_cnt == 4'h0) nxt_state = ST_SETUP; else nxt_state = ST_IDLE;
		ST_SETUP: nxt_state = ST_ACCESS;
		ST_ACCESS: begin
			if(pready_i) nxt_state = ST_IDLE;
		end
	endcase
end

logic ping_pong;

always_ff @( posedge clk or posedge reset ) begin
	if(reset)
		ping_pong <= 1'b1;
	else if(curr_state == ST_IDLE)
		ping_pong <= ~ping_pong;
end

assign psel_o = (curr_state == ST_SETUP) | (curr_state == ST_ACCESS);
assign penable_o = (curr_state == ST_ACCESS);
assign pwrite_o = ping_pong;
assign paddr_o = 32'hDEAD_CAFE;
assign pwdata_o = rdata_q +32'h1;

always_ff @( posedge clk or posedge reset ) begin
	if(reset) rdata_q = 31'h0;
	else if(penable_o && pready_i) rdata_q = rdata_q + 31'h1;
end

endmodule

module day3(
	input		wire		clk,
	input		wire		reset,

	input		wire		a_i,

	output		wire		rising_edge_o,
	output		wire		falling_edge_o
);

logic a_ff;
always_ff @(posedge clk or posedge reset) begin
	if(reset)
		a_ff <= 1'b0;
	else
		a_ff <= a_i;
end

assign rising_edge_o = a_i & ~a_ff;
assign falling_edge_o = ~a_i & a_ff;

endmodule

module day7(
	input		wire		clk,
	input		wire		reset,
	output		wire[3:0]	lfsr_o
);
logic[3:0] curr_lfsr, nxt_lfsr;
always_ff @(posedge clk or posedge reset) begin
	if(reset)
		curr_lfsr <= 4'hE;
	else
		curr_lfsr <= nxt_lfsr;
end

assign nxt_lfsr = {curr_lfsr[2:0], curr_lfsr[3] ^ curr_lfsr[1]};
assign lfsr_o = curr_lfsr;
endmodule