// Day 27
module day27_tb();
	parameter DEPTH = 8, DATA_W = 4;
	
	logic clk, reset, push_i, pop_i, full_o, empty_o;
	logic [DATA_W-1:0] push_data_i, pop_data_o;
	
	logic [DATA_W-1:0] queue[$];
	
	bit pop, push;
	bit [DATA_W-1:0] pop_data;
	
	day19 #(.DEPTH(DEPTH), .DATA_W(DATA_W)) DAY19(.*);
	
	always begin
		clk = 1'b1;
		#5;
		clk = 1'b0;
		#5;
	end
	
	initial begin
		reset = 1'b1;
		pop = 1'b0;
		push = 1'b0;
		push_i = 1'b0;
		pop_i = 1'b0;
		
		@(posedge clk);
		
		reset <= 1'b0;
		
		repeat(3) @(posedge clk);
		
		for(int i = 0; i < 512 ; i++) begin
			@(posedge clk);
			push_data_i <= $urandom_range(0, 15);
			pop = $urandom_range(0,5);
			push = $urandom_range(0,10);
			
			if(queue.size() == DEPTH) push = 0;
			if(queue.size() == 0) pop = 0;
			push_i = push;
			pop_i = pop;
			@(negedge clk); //check validity on negative edge.
			if(push_i) queue.push_back(push_data_i);
			if(pop_i) begin
				pop_data = queue.pop_front();
				if(pop_data_o !== pop_data) begin
					$fatal(1, "pop data doesn't match, expected 0x%8x, but got 0x%8x", pop_data, pop_data_o);
					$finish();
				end
			end
		end
		$finish();
	end
	
	initial begin
		$dumpfile("day27.vcd");
		$dumpvars(0, day27_tb);
	end
endmodule

module day19 #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);
	typedef enum logic [1:0] {	PUSH = 2'b01,
								POP = 2'b10,
								BOTH = 2'b11} fifo_state_t;
	
	parameter PTR_W = $clog2(DEPTH);
	
	logic [PTR_W : 0] rd_ptr_curr, rd_ptr_nxt, wr_ptr_curr, wr_ptr_nxt;
	logic [DATA_W-1 : 0] fifo_pop_data_ff;
	logic [DEPTH-1:0][DATA_W-1:0] FIFO_MEM;
	
	always_ff @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			rd_ptr_curr <= {PTR_W+1{1'b0}};
			wr_ptr_curr <= {PTR_W+1{1'b0}};

		end
		else
		begin
			rd_ptr_curr <= rd_ptr_nxt;
			wr_ptr_curr <= wr_ptr_nxt;
		end
	end
	
	always_comb begin
		rd_ptr_nxt = rd_ptr_curr;
        wr_ptr_nxt = wr_ptr_curr;
		fifo_pop_data_ff = FIFO_MEM[rd_ptr_curr[PTR_W-1:0]];
		case ({pop_i,push_i})
			PUSH: begin
				wr_ptr_nxt = wr_ptr_curr + {{PTR_W{1'b0}},1'b1};
			end
			POP: begin
				rd_ptr_nxt = rd_ptr_curr + {{PTR_W{1'b0}},1'b1};
				fifo_pop_data_ff = FIFO_MEM[rd_ptr_curr[PTR_W-1:0]];
			end
			BOTH: begin
				rd_ptr_nxt = rd_ptr_curr + {{PTR_W{1'b0}},1'b1};
				wr_ptr_nxt = wr_ptr_curr + {{PTR_W{1'b0}},1'b1};
			end
		endcase
	end
	
	always_ff @(posedge clk)
		if(push_i)
			FIFO_MEM[wr_ptr_curr[PTR_W-1:0]] <= push_data_i;
	
	assign full_o = (rd_ptr_curr[PTR_W] != wr_ptr_curr[PTR_W]) & (rd_ptr_curr[PTR_W-1:0] == wr_ptr_curr[PTR_W-1:0]);
	assign empty_o = (rd_ptr_curr[PTR_W:0] == wr_ptr_curr[PTR_W:0]);
	assign pop_data_o = fifo_pop_data_ff;
endmodule