// TB for round robin
`timescale 1ns/1ps
module day15_tb ();

  logic clk;
  logic reset;

  logic [3:0] req_i;
  logic [3:0]  gnt_o;
  
  day15 DAY15(.*);
  
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  initial begin
    $dumpfile("day15.vcd");
    $dumpvars(0, day15_tb);
    reset <= 1'b1;
    req_i <= 4'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<32; i++) begin
      req_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
	#1;
    $finish();
  end

endmodule
