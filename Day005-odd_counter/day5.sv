// Odd counter

module day5 (
  input     wire        clk,
  input     wire        reset,

  output    logic[7:0]  cnt_o
);

  logic [7:0] cnt_b;
  assign cnt_o = cnt_b;
  always_ff @(posedge clk or posedge reset)
    if(reset)
      cnt_b <= 8'h01;
  	else
    	cnt_b <= cnt_b + 8'h02;
  

endmodule
