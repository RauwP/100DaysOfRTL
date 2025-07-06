//day44 test

`ifndef DAY44_TEST
`define DAY44_TEST
`include "day44_env.sv"
`include "day44_item.sv"

class day44_test #(parameter NUM_PORTS = 8);

	day44_env #(.NUM_PORTS(NUM_PORTS)) env;
	
	mailbox drv_mx;
	
	day44_item #(.NUM_PORTS(NUM_PORTS)) item;
	
	function new();
		env = new();
		drv_mx = new();
	endfunction
	
	task gen_stim();
		for (int i = 0; i<512 ; i++) begin
			$display("%t: [TEST] Starting stim...", $time);
			item = new();
			void'(item.randomize());
			drv_mx.put(item);
			drv_mx.put(item);//send twice, once for the driver, once for the scoreboard
			#5;
		end
		$display("%t: [TEST] PASSED!", $time);
	endtask
	
	task run();
		env.drv.drv_mx = drv_mx;
		env.sb.drv_mx = drv_mx;
		fork
			env.run();
		join_none
		gen_stim();
	endtask
endclass
`endif