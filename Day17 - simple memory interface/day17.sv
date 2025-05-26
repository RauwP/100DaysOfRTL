module day17 (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,
  input       wire        req_rnw_i,    // 1 - read, 0 - write
  input       wire[3:0]   req_addr_i,
  input       wire[31:0]  req_wdata_i,
  output      wire        req_ready_o,
  output      wire[31:0]  req_rdata_o
);

  logic [15:0][31:0] mem;
  typedef enum logic [1:0] { 	IDLE = 2'd0,
                           		WAIT = 2'd1,
                            	READ_OR_WRITE = 2'd2} mem_state_t;
  
  logic[3:0] lfsr_o, delay_ff;
  mem_state_t curr_state, nxt_state;
  
  day7_mod #(4) DAY7_MOD(.*);
  
  always_ff @(posedge clk or posedge reset) begin
    if(reset)
      begin
        curr_state <= IDLE;
      end
    else
      begin
        curr_state <= nxt_state;
      end
  end
  
  always_ff @(posedge clk) begin
    if(curr_state == IDLE)
      delay_ff <= lfsr_o;
  	else if(curr_state == WAIT)
    	delay_ff <= delay_ff - 1;
  end
      
  always_ff @(posedge clk) begin
    if(curr_state == READ_OR_WRITE && ~req_rnw_i)
      mem[req_addr_i] <= req_wdata_i;
  end
  
  always_comb begin
    nxt_state = curr_state;
    case (curr_state)
      IDLE: begin
        if(req_i)
          nxt_state = WAIT;
        else
          nxt_state = IDLE;
      end
      WAIT: begin
        if (delay_ff == 0)
          nxt_state = READ_OR_WRITE;
        else
          nxt_state = WAIT;
      end
      READ_OR_WRITE: nxt_state = IDLE;
      default: nxt_state = IDLE;
    endcase
  end

  assign req_ready_o = (curr_state == READ_OR_WRITE) ? 1'b1 : 1'b0;
  assign req_rdata_o = (curr_state == READ_OR_WRITE && req_rnw_i) ? mem[req_addr_i] : '0;
endmodule

// LFSR
module day7_mod #(
  parameter SIZE = 4
) (
  input     wire      clk,
  input     wire      reset,

  output    wire[SIZE-1:0] lfsr_o
);

  logic [SIZE-1:0] lfsr_ff;
  always_ff @(posedge clk or posedge reset)
    if(reset)
      lfsr_ff <= 'hE;
  	else
      lfsr_ff<= {lfsr_ff[SIZE-2:0],lfsr_ff[SIZE-1] ^ lfsr_ff[SIZE-3]};
  assign lfsr_o = lfsr_ff;

endmodule