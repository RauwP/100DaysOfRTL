`include "prim_assert.sv"
// Counter with a load
module day49 (
  input     wire          clk,
  input     wire          reset,
  input     wire          load_i,
  input     wire[3:0]     load_val_i,

  output    wire[3:0]     count_o
);

  logic [3:0] load_ff;
  logic [3:0] nxt_cnt;
  logic [3:0] cnt_ff;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      load_ff <= 4'h0;
  	else if(load_i)
      load_ff <= load_val_i;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      cnt_ff <= 4'h0;
  	else
    	cnt_ff <= nxt_cnt;
  assign nxt_cnt = load_i ? load_val_i : (cnt_ff == 4'hF) ? load_ff : cnt_ff + 4'h1;
  assign count_o = cnt_ff;
  		
	
	
	`ifdef FORMAL
		
		logic rst_one_cycle = 1'b0;
		always_ff @(posedge clk) begin
			rst_one_cycle <= 1'b1;
			
			assume (rst_one_cycle ^ reset);
		end
		
		`ASSUME_ZERO_IN_RESET(load_i)
		
		logic[3:0] load_val_latch;
		
		always_ff @(posedge clk)
			if(reset)
				load_val_latch <= 4'h0;
			else if(load_i)
				load_val_latch <= load_val_i;
		
		`ASSERT(load_val_chk, `IMPLIES($fell(load_i), $past(load_val_i) == count_o))
		
		`ASSERT(reload_val_chk, `IMPLIES(~$past(reset) & ~$past(load_i) & $past(count_o == 4'hF), count_o == load_val_latch))
		
		`ASSERT(incr_val_chk, `IMPLIES($past(count_o != 4'hF) & ~$past(reset) & ~$past(load_i), $past(count_o) + 4'h1 == count_o))
	`endif	
endmodule
