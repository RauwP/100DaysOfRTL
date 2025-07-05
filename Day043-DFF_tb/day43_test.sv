`ifndef DAY43_TEST
`define DAY43_TEST

`include "day43_item.sv"
`include "day43_sb.sv"
`include "day43_monitor.sv"
`include "day43_driver.sv"
`include "day43_if.sv"
class day43_test;

	day43_driver drv;
	day43_monitor mon;
	day43_sb sb;
	
	mailbox async_sb_mx, sync_sb_mx;
	
	virtual day43_if vif;
	
	function new();
		drv = new();
		mon = new();
		sb = new();
		async_sb_mx = new();
		sync_sb_mx = new();
	endfunction
	
	task run();
		drv.vif = vif;
		mon.vif = vif;
		sb.vif = vif;
		
		mon.sync_sb_mx = sync_sb_mx;
		mon.async_sb_mx = async_sb_mx;
		
		sb.sync_sb_mx = sync_sb_mx;
		sb.async_sb_mx = async_sb_mx;
		$display("%t: [TEST] Starting test...", $time);
		fork
			drv.run();
			mon.run();
			sb.run();
		join_none
	endtask
endclass
`endif	