`include "day64.sv"
`timescale 1ns/1ps

import day64::*;

module day64_tb();
  logic lines[8:0];
  wire  dummy_wire[8:0] = lines;
  initial begin
    $dumpfile("day64.vcd");
    $dumpvars(0, day64_tb);     
  end
  
  initial begin
		print_bring_them_home_now(lines);
		#1;
		$finish();
  end

endmodule