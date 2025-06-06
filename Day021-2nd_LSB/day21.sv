module day21 #(
  parameter WIDTH = 12
)(
  input       wire [WIDTH-1:0]  vec_i,
  output       wire [WIDTH-1:0]  second_bit_o

);
  logic [WIDTH-1:0] first,first_masked,second;
  day14 #(.NUM_PORTS(WIDTH)) first_lsb(	.req_i(vec_i),
                                      	.gnt_o(first));
  assign first_masked = vec_i & ~first;
  
  day14 #(.NUM_PORTS(WIDTH)) second_lsb(	.req_i(first_masked),
                                        	.gnt_o(second));
  
  assign second_bit_o = second;

endmodule
