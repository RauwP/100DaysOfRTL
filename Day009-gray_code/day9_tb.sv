`timescale 1ns/1ps
module day9_tb ();

	parameter VEC_W = 5;
  
  logic [VEC_W-1:0] bin_i;
  logic [VEC_W-1:0] gray_o;
  
  day9 #(VEC_W) DAY9(.*);
  
  initial begin
    $dumpfile("day9.vcd");
    $dumpvars(0, day9_tb);
    for (int i=0 ; i<2**VEC_W;i++) begin
      bin_i = i;
      #5;
    end
	#1;
    $finish();
  end

endmodule
