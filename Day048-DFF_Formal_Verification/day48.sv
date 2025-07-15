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


	`ifdef FORMAL
    // This flop is used to identify the initial state (time 0).
    logic not_initial_state = 1'b0;
    always_ff @(posedge clk) not_initial_state <= 1'b1;
	
	`ASSUME(Initrst, `IMPLIES(~not_initial_state, reset))
	
    // This assertion is not disabled by the `reset` signal.
    `ASSERT_NODIS(NoRstFlop_A, `IMPLIES(not_initial_state,(q_norst_o == $past(d_i))))

    //This single assertion checks both the reset and data-latching behavior.
    `ASSERT(SyncRstFlop_A, `IMPLIES(not_initial_state,(q_syncrst_o == ($past(reset) ? 1'b0 : $past(d_i)))))

    //The asynchronous reset behavior is combinational and must be checked immediately
    `ASSERT_I(AsyncRstFlopAsyncReset_A, `IMPLIES(reset, q_asyncrst_o == 1'b0))
    //The synchronous data path is only checked when reset is low.
    `ASSERT(AsyncRstFlopData_A, `IMPLIES(not_initial_state, (q_asyncrst_o == ($past(reset) ? 1'b0 : $past(d_i)))))
	`endif
endmodule
