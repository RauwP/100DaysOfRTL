//day50
`include "prim_assert.sv"
module day50 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
	assign gnt_o[0] = req_i[0];
	genvar i;
	for(i = 1 ; i< NUM_PORTS ; i=i+1) assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);


	`ifndef FORMAL
		
		`ASSUME(req_nonzero, `IMPLIES(1'b1, (req_i !== NUM_PORTS'(1'b0)))
		
		`ASSERT(gnt_onehot, $countones(gnt_o) <= 1)
		
		`ASSERT(gnt_req0, `IMPLIES(req_i[0], (gnt_o == NUM_PORTS'(1'b1))))
		
		for(genvar i = 1 ; i < NUM_PORTS ; i=i+1) begin : g_gnt_req_assert
			always_ff @(*) assert((req_i[i] & ~|req[i-1:0]) | (!gnt_o[i]));
		end
	`endif
endmodule