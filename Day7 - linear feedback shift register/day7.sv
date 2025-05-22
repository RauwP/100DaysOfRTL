// LFSR
module day7 (
  input     wire      clk,
  input     wire      reset,

  output    wire[3:0] lfsr_o
);

  logic [3:0] lfsr_ff;
  always_ff @(posedge clk or posedge reset)
    if(reset)
      lfsr_ff <= 4'hE;
  	else
      lfsr_ff<= {lfsr_ff[2:0],lfsr_ff[1] ^ lfsr_ff[3]};
  assign lfsr_o = lfsr_ff;

endmodule
