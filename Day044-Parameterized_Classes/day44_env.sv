//day44 env
`ifndef DAY44_ENV
`define DAY44_ENV
`include "day44_item.sv"
`include "day44_sb.sv"
`include "day44_monitor.sv"
`include "day44_driver.sv"
//`include "day44_if.sv"

class day44_env #(parameter NUM_PORTS = 8);

	day44_driver	#(.NUM_PORTS(NUM_PORTS))	drv;
	day44_monitor	#(.NUM_PORTS(NUM_PORTS))	mon;
	day44_sb		#(.NUM_PORTS(NUM_PORTS))	sb;
	
	mailbox sb_mx;
	
	virtual day44_if #(.NUM_PORTS(NUM_PORTS)) vif;
	
	function new();
		drv = new;
		mon = new;
		sb = new;
		sb_mx = new;
	endfunction
	
	task run();
		
		drv.vif = vif;
		mon.vif = vif;
		
		mon.sb_mx = sb_mx;
		sb.sb_mx = sb_mx;
		
		fork
			drv.run();
			mon.run();
			sb.run();
		join_any
	endtask
endclass
`endif