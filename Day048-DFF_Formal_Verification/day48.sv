`include "prim_assert.sv"
// Different DFF

module day48 (
  input     logic      clk,
  input     logic      reset,

  input     logic      d_i,

  output    logic      q_norst_o,
  output    logic      q_syncrst_o,
  output    logic      q_asyncrst_o
);

  always_ff @(posedge clk)
    q_norst_o <= d_i;
  
  always_ff @(posedge clk)
    if(reset)
      q_syncrst_o <= 1'b0;
  	else
      q_syncrst_o <= d_i;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      q_asyncrst_o <= 1'b0;
  	else
      q_asyncrst_o <= d_i;


	`ifndef FORMAL
	
		
		//norst get the previous d_i no matter what.
		`ASSERT_NODIS(NoRstFlop_A, q_norst_o == $past(d_i))
		
		//syncrst gets d_i if in the previous cycle rst wasnt raised, if it was then it gets zero.
		`ASSERT(SyncRstFlopReset_A, `IMPLIES($past(reset), q_syncrst_o == 1'b0))
		`ASSERT(SyncRstFlopData_A, `IMPLIES(!$past(reset), q_syncrst_o == $past(d_i)))

		//asyncrst gets zero immidiatley if the rst is raised
		`ASSERT_I(AsyncRstFlopAsyncReset_A, `IMPLIES(reset, q_asyncrst_o == 1'b0))
		`ASSERT(AsyncRstFlopReset_A, `IMPLIES($past(reset), q_asyncrst_o == 1'b0))
		`ASSERT(AsyncRstFlopData_A, `IMPLIES(!$past(reset), q_asyncrst_o == $past(d_i)))
	`endif
endmodule
