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
  		
	
	
	`ifndef FORMAL
		
		`ASSERT(load_val_chk, `IMPLIES($past(load_i), count_o == $past(load_val_i)))
		
		`ASSERT(reload_val_chk, `IMPLIES($past(count_o) == 4'hF, count_o == load_ff))
		
		`ASSERT(incr_val_chk, `IMPLIES(!$past(load_i) & !$past(reset) & $past(count_o != 4'hF), count_o == $past(count_o) + 4'h1))
		
	`endif	
endmodule
