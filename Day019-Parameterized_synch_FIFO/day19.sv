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