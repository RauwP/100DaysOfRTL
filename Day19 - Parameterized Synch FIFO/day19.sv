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
	logic [DEPTH-1:0][DATA_W-1:0] FIFO;
	logic [$clog2(DEPTH) - 1:0] wr_ptr, rd_ptr, occu_mem;
	logic [DATA_W-1:0] pop_data_o_ff;
	always_ff @(posedge clk or posedge reset) begin
		if(reset)begin
			wr_ptr <= '0;
			rd_ptr <= '0;
			occu_mem <= '0;
			pop_data_o_ff <= '0;
		end
		else
		begin
			if(push_i && pop_i)
			begin
				occu_mem <= occu_mem;
				if(!empty_o)
				begin
					FIFO[wr_ptr] <= push_data_i;
					pop_data_o_ff <= FIFO[rd_ptr];
					wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
					rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
				end
				else
				begin
					pop_data_o_ff <= push_data_i;
				end
			end     
			else
			begin
				if(push_i && !full_o)
				begin
					rd_ptr <= rd_ptr;
					wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
					FIFO[wr_ptr] <= push_data_i;
					occu_mem <= occu_mem+1;
					pop_data_o_ff <= '0;
				end
				else if(pop_i && !empty_o)
				begin
					rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
					pop_data_o_ff <= FIFO[rd_ptr];
					occu_mem <= occu_mem-1;	
				end
				else
				begin
					pop_data_o_ff <= '0;
				end
			end				
		end
	end
	assign pop_data_o = pop_data_o_ff;
	assign empty_o = (occu_mem == 0);
	assign full_o = (occu_mem == DEPTH);
endmodule