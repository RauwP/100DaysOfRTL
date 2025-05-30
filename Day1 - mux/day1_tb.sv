// A simple TB for mux
`timescale 1ns/1ps
module day1_tb();
  logic [7:0] a_i;
  logic [7:0] b_i;
  logic sel_i;
  logic [7:0] y_o;
  
  day1 DAY1(.*);
  
  initial begin
    $dumpfile("day1.vcd");
    $dumpvars(0, day1_tb);
    for(int i = 0; i < 10; i++) begin
      a_i = $urandom_range (0, 8'hFF);
      b_i = $urandom_range (0, 8'hFF);
	  sel_i = $random%2;
      #5;
    end
	#1;
    $finish();
  end


endmodule
