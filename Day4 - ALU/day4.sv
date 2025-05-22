// A simple ALU

module day4 (
  input     logic [7:0]   a_i,
  input     logic [7:0]   b_i,
  input     logic [2:0]   op_i,

  output    logic [7:0]   alu_o
);

  logic c;
  always_comb begin
  	case (op_i)
    	3'b000://ADD
    		{c,alu_o} = {1'b0,a_i} + {1'b0,b_i};
    	3'b001://SUB
    	  alu_o = a_i - b_i;
    	3'b010://SLL
    	  alu_o = a_i[7:0] << b_i[2:0];
    	3'b011://LSR
        alu_o = a_i[7:0]>>b_i[2:0];
    	3'b100://AND
    	  alu_o = a_i[7:0] & b_i[7:0];
    	3'b101://OR
    	  alu_o = a_i | b_i;
    	3'b110://XOR
    	  alu_o = a_i ^ b_i;
    	3'b111://EQUAL
    	  alu_o = {7'h0,a_i == b_i};
  	endcase
  end
      

endmodule
