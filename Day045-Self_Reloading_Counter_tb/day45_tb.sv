//day45 tb
`include "day45_test.sv"
`include "day45_if.sv"
module day45_tb();

	logic clk, reset;
	
	day45_if intf(clk, reset);
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
		reset = 1'b1;
		repeat (3) @(posedge clk);
		reset = 1'b0;
	end
	
	day10 DAY10(
		.clk(clk),
		.reset(reset),
		.load_i(intf.load),
		.load_val_i(intf.load_val),
	    .count_o(intf.count)
	);
	day45_test test;
	
	initial begin
		
		$dumpfile("day45.vcd");
		$dumpvars(0, day45_tb);
		
		test = new();
		test.env.vif = intf;
		test.run();
		$finish();
	end
	
endmodule