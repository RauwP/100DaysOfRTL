// Day 36 actually

class day28;
	
	rand bit [15:0] req_addr;
	rand bit [31:0] req_wdata;
	
endclass

module day36_tb();
	
	logic clk, reset, req_i, req_rnw_i, req_ready_o;
	logic [15:0] req_addr_i;
	logic [31:0] req_rdata_o, req_wdata_i;
	
	bit [15:0] addr_lst[$]; //Managing the address list as a queue
	bit [31:0] mem_table[bit[15:0]]; //Associative Array for comparison
	
	day17 DAY17(.*);
	day28 DAY28;
	always begin
		clk = 1'b1;
		#5;
		clk = 1'b0;
		#5;
	end
	
	task wr_tx(int num_tx);
		$display("Starting write for %0d transactions...", num_tx);
		int cnt = 0;
		for (int i=0 ; i<num_tx ; i++) begin
			@(posedge clk);
			req_i <= 1'b1;
			req_rnw_i <= 1'b0;
			void'(DAY28.randomize());
			req_addr_i <= DAY28.req_addr;
			req_wdata_i <= DAY28.req_wdata;
			
			mem_table[DAY28.req_addr] = DAY28.req_wdata;
			addr_lst.push_back(DAY28.req_addr);
			
			fork : waitAndTimeoutBlock
				begin
					while (~req_ready_o) @(posedge clk);
				end
				
				begin
					cnt = 0;
					while(1) begin
						if(cnt == 16) $fatal(1,"%t: Watchdog timeout! Didn't receive ready for 16 cycles.", $time);
						@(posedge clk);
						cnt++;
					end
				end
			join_any
			disable waitAndTimeoutBlock; //since we got here we want to stop that fork, and let the checking continue.
			req_i <= 1'b0;
		end
		$display("Write phase complete.");
	endtask
	
	task rd_and_check_tx(int num_tx);
		$display("Starting read and check for %0d transactions...", num_tx);
		for (int i=0 ; i<num_tx ; i++) begin
			@(posedge clk);
			req_i <= 1'b1;
			req_rnw_i <= 1'b1;
			addr_lst.shuffle();
			req_addr_i <= addr_lst[0];
			void'(DAY28.randomize());
			req_wdata_i <= DAY28.req_wdata;
			
			while (~req_ready_o) @(posedge clk);
			
			if(req_rdata_o !== mem_table[addr_lst[0]]) $fatal(1, "Data Mismatch! Addr: %h, Expected: %h, Got: %h", addr_lst[0], mem_table[addr_lst[0]], req_rdata_o);
			
			req_i <= 1'b0;
		end
		$display("Read and check phase complete.");
	endtask
			
	initial begin
		reset <= 1'b1;
		req_i <= 1'b0;
		DAY28 = new();
		@(posedge clk);
		reset <= 1'b0;
		repeat(3) @(posedge clk);
		wr_tx(10);
		repeat(5) @(posedge clk);
		rd_and_check_tx(10);
		$display("TEST PASSED");
		$finish();
	end
	
	initial begin
		$dumpfile("day36.vcd");
		$dumpvars(0, day36_tb);
	end
endmodule

module day17(
  input       wire        clk,
  input       wire        reset,

  input       wire			req_i,
  input       wire        	req_rnw_i,    // 1 - read, 0 - write
  input       wire[15:0]   	req_addr_i,
  input       wire[31:0]  	req_wdata_i,
  output      wire        	req_ready_o,
  output      wire[31:0]  	req_rdata_o
);

	logic [2**16-1:0][31:0] mem;
	
	logic mem_rd, mem_wr, req_rising_edge;
	logic [3:0] lfsr_val, cnt, cnt_ff, nxt_cnt;
	
	assign mem_rd = req_i & req_rnw_i;
	assign mem_wr = req_i & ~req_rnw_i;
	assign nxt_cnt = req_rising_edge ? lfsr_val : cnt_ff + 4'h1;
	assign cnt = cnt_ff;
	assign req_ready_o = ~|cnt;
	assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};

	
	day3 DAY3(.clk(clk), .reset(reset), .a_i(req_i), .rising_edge_o(req_rising_edge), .falling_edge_o());
	
	day7 DAY7(.clk(clk), .reset(reset), .lfsr_o(lfsr_val));
	
	always_ff @(posedge clk or posedge reset) begin
		if(reset)
			cnt_ff <= 4'h0;
		else
			cnt_ff <= nxt_cnt;
	end
	always_ff @(posedge clk) begin
		if(mem_wr & ~|cnt) begin
			mem[req_addr_i] <= req_wdata_i;
		end
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
	
	always_ff @(posedge clk or posedge reset)
		if(reset)
			a_ff <=1'b0;
		else
			a_ff <= a_i;
	
	assign rising_edge_o = ~a_ff & a_i;
	assign falling_edge_o = a_ff & ~a_i;
endmodule

module day7(
	input		wire		clk,
	input		wire		reset,
	output		wire[3:0]	lfsr_o
	);
	
	logic [3:0] lfsr_ff, lfsr_nxt;
	
	always_ff @(posedge clk or posedge reset)
		if(reset)
			lfsr_ff <= 4'hE;
		else
			lfsr_ff <= lfsr_nxt;
	
	assign lfsr_nxt = {lfsr_ff[2:0], lfsr_ff[1] ^ lfsr_ff[3]};
	assign lfsr_o = lfsr_ff;
endmodule