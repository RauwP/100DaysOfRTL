// Parallel to serial with valid and empty

module day11 (
  input     wire      clk,
  input     wire      reset,

  output    logic      empty_o,
  input     wire[3:0] parallel_i,
  
  output    logic      serial_o,
  output    logic      valid_o
);
  logic [3:0] shift_ff;
  logic [2:0] cnt_ff;
  always_ff @(posedge clk or posedge reset)
  begin
    if(reset)
    begin
			empty_o <= 1'b1;
      serial_o <= 1'b0;
      valid_o <= 1'b0;
      cnt_ff <= 3'h0;
      shift_ff <= 4'h0;
    end
    else if(cnt_ff == 3'd4)
    begin
			shift_ff <= parallel_i;
      empty_o <= 1'b1;
      serial_o <= 1'b0;
      valid_o <= 1'b0;
      cnt_ff <= 3'h0;
    end
    else
    begin
      shift_ff <= {1'b0, shift_ff[3:1]};
      serial_o <= shift_ff[0];
      cnt_ff <= cnt_ff + 3'h1;
      valid_o <= 1'b1;
      empty_o <= 1'b0;
    end
  end

endmodule
