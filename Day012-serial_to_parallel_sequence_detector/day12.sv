// Detecting a big sequence - 1110_1101_1011
module day12 (
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,

  output    wire        det_o
);
  localparam logic [11:0] bvec = 12'b1110_1101_1011;
  logic [11:0] shift_reg_ff;
  logic det_ff;
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
        shift_reg_ff<=12'h0;
      	det_ff <= 1'b0;
        end
      else
        begin
          shift_reg_ff <= {shift_reg_ff[10:0], x_i};
          det_ff <= (shift_reg_ff == bvec);
        end
    end
  assign det_o = det_ff;
endmodule
