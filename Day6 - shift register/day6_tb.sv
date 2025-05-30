`timescale 1ns/1ps
module day6_tb ();
  logic clk;
  logic reset;
  logic x_i;
  logic [3:0] sr_o;

  day6 DAY6(.*);
  
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  initial begin
    $dumpfile("day6.vcd");
    $dumpvars(0, day6_tb);
    reset <= 1'b1;
    x_i <= 1'b0;
    @(posedge clk)
    @(posedge clk)
    reset <= 1'b0;
    for(int i=0;i<16;i++) begin
      x_i <= $random%2;
      @(posedge clk);
    end
	#1;
    $finish();
  end
endmodule
