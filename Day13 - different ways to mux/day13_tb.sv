// Simple TB

module day13_tb ();

  logic [3:0] a_i;
  logic [3:0] sel_i;
  logic y_ter_o;
  logic y_case_o;
  logic y_ifelse_o;
  logic y_loop_o;
  logic y_aor_o;
  
  day13 DAY13(.*);
  
  initial begin
    for (int i = 0; i<32; i++) begin
      a_i = $urandom_range(0, 4'hF);
      sel_i = 1'b1 << $urandom_range(0, 2'h3);
      #5;
    end
    $finish();
  end

endmodule
