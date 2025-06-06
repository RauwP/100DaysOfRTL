// Round robin arbiter

module day15 (
  input     wire        clk,
  input     wire        reset,

  input     wire[3:0]   req_i,
  output    logic[3:0]  gnt_o
);

  logic [3:0] mask_q, nxt_mask, mask_req, mask_gnt, raw_gnt;
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      mask_q <= 4'hF;
  	else
    	 mask_q <= nxt_mask;
  
  always_comb begin
    nxt_mask = mask_q;
    if (gnt_o[0]) nxt_mask = 4'b1110;
    else if (gnt_o[1]) nxt_mask = 4'b1100;
    else if (gnt_o[2]) nxt_mask = 4'b1000;
    else if (gnt_o[3]) nxt_mask = 4'b0000;
  end
  
  assign mask_req = req_i & mask_q;
  
  day14 #(4) maskedGnt (.req_i(mask_req), .gnt_o(mask_gnt));
  day14 #(4) rawGnt (.req_i(req_i), .gnt_o(raw_gnt));
  
  assign gnt_o = (|mask_req) ? mask_gnt : raw_gnt;
  

endmodule
