 // An edge detector

module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

  logic a_i_p;
  always_ff @(posedge clk or posedge reset)
    if (reset)
    	a_i_p <= 1'b0;
  	else
      a_i_p <= a_i;
  assign rising_edge_o = ~a_i_p & a_i;
  assign falling_edge_o = a_i_p & ~a_i;

endmodule
