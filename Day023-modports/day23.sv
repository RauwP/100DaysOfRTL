// Day23 Interface

interface day23 (
  input		wire		clk,
  input		wire		reset
);
  
  logic			psel;
  logic			penable;
  logic[31:0]	paddr;
  logic			pwrite;
  logic[31:0]	pwdata;
  logic[31:0]	prdata;
  logic			pready;
  
  modport apb_master (
    input		psel,
    input		penable,
    input		paddr,
    input		pwrite,
    input		pwdata,
    output		prdata,
    output		pready
  );
  
  modport apb_slave (
    output		psel,
    output		penable,
    output		paddr,
    output		pwrite,
    output		pwdata,
    input 		prdata,
    input		pready
  );
  
endinterface

module day16 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  day23.apb_master        apb_if
);

  // Enum for the APB state
  typedef enum logic[1:0] {IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10} apb_state_t;

  apb_state_t nxt_state, cur_state;

  logic[31:0] rdata_ff;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      cur_state <= IDLE;
    else
      cur_state <= nxt_state;

  always_comb begin
    nxt_state = cur_state;
    case (cur_state)
      IDLE   : if (|cmd_i) nxt_state = SETUP; else nxt_state = IDLE;
      SETUP  : nxt_state = ACCESS;
      ACCESS : begin
        if (apb_if.pready) nxt_state = IDLE;
      end
    endcase
  end

  assign apb_if.psel     = (cur_state == SETUP) | (cur_state == ACCESS);
  assign apb_if.penable  = (cur_state == ACCESS);
  assign apb_if.pwrite   = cmd_i[1];
  assign apb_if.paddr    = 32'hDEAD_CAFE;
  assign apb_if.pwdata   = rdata_ff + 32'h1;

  // Capture the read data to store it for the next write
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata_ff <= 32'h0;
  else if (apb_if.penable && apb_if.pready)
      rdata_ff <= apb_if.prdata;

endmodule