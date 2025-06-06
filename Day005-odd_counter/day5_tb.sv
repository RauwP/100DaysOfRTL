// Simple TB
`timescale 1ns/1ps
module day5_tb ();

  logic clk;
  logic reset;
  logic[7:0]  cnt_o;

  day5 DAY5(.*);
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  initial begin
    $dumpfile("day5.vcd");
    $dumpvars(0, day5_tb);
    reset <= 1'b1;
    @(posedge clk)
    @(posedge clk)
    reset <= 1'b0;
    for(int i=0;i<128;i++)begin
      @(posedge clk);
    end
	#1;
    $finish();
  end
endmodule
