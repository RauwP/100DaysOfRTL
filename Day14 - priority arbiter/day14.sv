// Priority arbiter
// port[0] - highest priority

module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
	logic grant_pending;
  logic [NUM_PORTS-1:0] gnt_o_ff;
  
  always_comb begin
    grant_pending = 1'b1;
    gnt_o_ff = '0;
    for(int i=0;i<NUM_PORTS;i++) begin
      if(req_i[i] && grant_pending)
        begin
          gnt_o_ff[i] = 1'b1;
          grant_pending = 1'b0;
        end
    end
  end
  assign gnt_o = gnt_o_ff;

endmodule
