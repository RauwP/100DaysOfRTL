//day55
`include "prim_assert.sv"
module day55 #(
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
	
	`ifdef FORMAL
		//reset is asserted for one cycle at the begining
		logic rst_one_cycle = 1'b0;
		always_ff @(posedge clk) begin
			rst_one_cycle <= 1'b1;
			assume(reset ^ rst_one_cycle);
		end
		//golden counter of how many addresses are used
		logic [$clog2(DEPTH):0] used_count;
		
		always_ff @(posedge clk or posedge reset) begin
			if(reset)
				used_count <= '0;
			else
				used_count <= used_count - pop_i + push_i;
		end
		
		`ASSERT(full_chk, `IMPLIES(used_count == DEPTH, full_o))
		
		`ASSERT(not_full_chk, `IMPLIES(used_count != DEPTH, ~full_o))
		
		`ASSERT(empty_chk, `IMPLIES(used_count == '0, empty_o))
		
		`ASSERT(not_empty_chk, `IMPLIES(used_count != '0, ~empty_o))
		
		`ASSUME(pop_legal, `IMPLIES(pop_i, ~empty_o))
	`endif
endmodule