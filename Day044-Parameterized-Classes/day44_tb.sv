//day44 tb
`include "day44_test.sv"
`include "day44_if.sv"
module day44_tb();

	localparam NUM_PORTS = 17;
	
	day44_if #(.NUM_PORTS(NUM_PORTS)) intf();
	
	day14 #(.NUM_PORTS(NUM_PORTS)) DAY14(
		.req_i(intf.req),
      .gnt_o(intf.gnt)
	);
	
	day44_test #(.NUM_PORTS(NUM_PORTS)) test;
	
	initial begin
		
		$dumpfile("day44.vcd");
		$dumpvars(0, day44_tb);
		
		test = new();
		test.env.vif = intf;
		test.run();
		$finish();
	end
	
endmodule