`timescale 1ns/1ps
module day11_tb ();

  logic clk;
  logic reset;
  logic empty_o;
  logic [3:0] parallel_i;
  logic serial_o;
  logic valid_o;
  
  day11 DAY11(.*);
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  initial begin
    $dumpfile("day11.vcd");
    $dumpvars(0, day11_tb);
    reset <= 1'b1;
    parallel_i <= 4'h0;
    @(negedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for(int i=0;i<32;i++)begin
      parallel_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
	#1;
    $finish();
  end

endmodule
