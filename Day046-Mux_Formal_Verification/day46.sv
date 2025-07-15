// day1.sv
`include "prim_assert.sv"

module day46 (
  input   wire [7:0]    a_i,
  input   wire [7:0]    b_i,
  input   wire          sel_i,
  output  wire [7:0]    y_o
);
  assign y_o = sel_i ? a_i : b_i;

	`ifdef FORMAL
  // Add assertions to check the mux output
  // sel_i |-> y_o == a_i
  `ASSERT(check_sel_high, `IMPLIES(sel_i, (y_o == a_i)))
  // ~sel_i |-> y_o == b_i
  `ASSERT(check_sel_low, `IMPLIES(~sel_i, (y_o == b_i)))
	`endif
endmodule
