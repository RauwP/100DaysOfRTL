//day51
`include "prim_assert.sv"
module day51 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);

  typedef enum logic [1:0] { IDLE = 2'd0,
                           SETUP  = 2'd1,
                           ACCESS = 2'd2 } apb_state_t;
  apb_state_t curr_state, nxt_state;
  
  logic [31:0] rdata_ff;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      curr_state <= IDLE;
      rdata_ff <= 32'h0;
    end
  	else begin
      curr_state <= nxt_state;
      if (curr_state == ACCESS && pready_i && cmd_i == 2'b01)
        rdata_ff <= prdata_i;
    end
  end
  
  always_comb begin
    nxt_state = curr_state;
    case (curr_state)
      IDLE: if (|cmd_i) nxt_state = SETUP; else nxt_state = IDLE;
      SETUP: nxt_state = ACCESS;
      ACCESS: if (pready_i) nxt_state = IDLE;
      default: nxt_state = curr_state;
    endcase
  end
  
  assign psel_o = (curr_state == SETUP) | (curr_state == ACCESS);
  assign penable_o = (curr_state == ACCESS);
  assign pwrite_o = cmd_i[1];
  assign paddr_o = 32'hDEAD_CAFE;
  assign pwdata_o = rdata_ff + 32'h1;



	`ifdef FORMAL
	
		//reset is one for one cycle at the start of the sim
		logic rst_one_cycle = 1'b0;
		always_ff @(posedge clk) begin
			rst_one_cycle <= 1'b1;
			
			assume (rst_one_cycle ^ reset);
		end
		
		//we dont want the cmd to change while doing something
		`ASSUME(cmd_stable, `IMPLIES(~pready_i | ~penable_o, $stable(cmd_i)))
		
		//we dont allow 2'b11
		`ASSUME(cmd_valid, `IMPLIES(~pready_i | ~penable_o, (cmd_i != 2'b11)))
		
		//write instruct
		`ASSERT(cmd_chk0, `IMPLIES((cmd_i == 2'b10) & penable_o & ~pready_i, pwrite_o))
		
		//read instruct
		`ASSERT(cmd_chk1, `IMPLIES((cmd_i == 2'b01) & penable_o & ~pready_i, ~pwrite_o))
		
		//to check if psel rose
		logic asrt_psel_rising;
		
		always_ff @(posedge clk) asrt_psel_rising <= $rose(psel_o);
		
		//penable needs to rise after psel rose as per the state machine
		`ASSERT(penable_chk, `IMPLIES($rose(penable_o), asrt_psel_rising))
		
		//checking if signals are stabke when not in the write/read cycle, this is the only time we want them to change
		`ASSERT(psel_stable, `IMPLIES(penable_o & ~pready_i, $stable(psel_o)))
		
		`ASSERT(pwrite_stable, `IMPLIES(penable_o & ~pready_i, $stable(pwrite_o)))
		
		`ASSERT(pwdata_stable, `IMPLIES(penable_o & ~pready_i, $stable(pwdata_o)))
		
		`ASSERT(paddr_stable, `IMPLIES(penable_o & ~pready_i, $stable(paddr_o)))
		
	`endif
endmodule