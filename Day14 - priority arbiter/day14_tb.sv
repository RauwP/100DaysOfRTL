`timescale 1ns/1ps
module day14_tb ();

  parameter NUM_PORTS = 4;
  logic [NUM_PORTS-1:0] req_i;
  logic [NUM_PORTS-1:0] gnt_o;
  
  day14 #(NUM_PORTS) DAY14(.*);
  
  initial begin
    $dumpfile("day14.vcd");
    $dumpvars(0, day14_tb);
    for (int i=0;i<2**NUM_PORTS;i++) begin
      req_i = i;
      #5;
    end
	#1;
    $finish();
  end

endmodule
