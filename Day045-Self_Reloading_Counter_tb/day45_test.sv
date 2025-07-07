//day45 test

`ifndef DAY45_TEST
`define DAY45_TEST
`include "day45_env.sv"
`include "day45_item.sv"

class day45_test;

	day45_env env;
	
	mailbox drv_mx;
	
	day45_item item;
	
	function new();
		env = new();
		drv_mx = new();
	endfunction
	
	task gen_stim();
		@(negedge env.vif.reset);
		for (int i = 0; i<512 ; i++) begin
			@(posedge env.vif.clk);
			$display("%t: [TEST] Starting stim...", $time);
			item = new();
			void'(item.randomize());
			drv_mx.put(item);
			#5;
		end
		$display("%t: [TEST] PASSED!", $time);
	endtask
	
	task run();
		env.drv.drv_mx = drv_mx;
		fork
			env.run();
		join_none
		gen_stim();
	endtask
endclass
`endif