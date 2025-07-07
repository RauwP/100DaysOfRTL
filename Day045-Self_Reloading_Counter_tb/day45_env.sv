//day45 env
`ifndef DAY45_ENV
`define DAY45_ENV
`include "day45_item.sv"
`include "day45_sb.sv"
`include "day45_monitor.sv"
`include "day45_driver.sv"
//`include "day45_if.sv"

class day45_env;

	day45_driver drv;
	day45_monitor mon;
	day45_sb sb;
	
	mailbox sb_mx;
	
	virtual day45_if vif;
	
	function new();
		drv = new;
		mon = new;
		sb = new;
		sb_mx = new;
	endfunction
	
	task run();
		
		drv.vif = vif;
		mon.vif = vif;
		sb.vif = vif;
		
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