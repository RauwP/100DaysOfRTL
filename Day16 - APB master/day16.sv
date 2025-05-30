// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE

module day16 (
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

endmodule
