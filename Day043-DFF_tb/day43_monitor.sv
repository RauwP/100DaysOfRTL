`ifndef DAY43_MONITOR
`define DAY43_MONITOR

`include "day43_item.sv"
class day43_monitor;
	
	day43_item s_item, as_item;
	
	virtual day43_if vif;
	
	mailbox async_sb_mx, sync_sb_mx;
	
	function void s_sample(day43_item item);
		item.d = vif.cb.d_i;
		item.reset = vif.reset;
		item.q_norst = vif.cb.q_norst_o;
		item.q_syncrst = vif.cb.q_syncrst_o;
		item.q_asyncrst =vif.reset ? 1'b0 : vif.cb.q_asyncrst_o;
	endfunction
  
  	function void as_sample(day43_item item);
		item.d = vif.cb.d_i;
		item.reset = vif.reset;
		item.q_norst = vif.cb.q_norst_o;
		item.q_syncrst = vif.cb.q_syncrst_o;
		item.q_asyncrst = vif.q_asyncrst_o;
	endfunction
	
	task sync_monitor();
		$display("%t: [SYNC-MONITOR] Starting...", $time);
		
		forever begin
			@(vif.cb);
          	//#1;
			s_item = new();
			s_sample(s_item);
			s_item.print("SYNC-MONITOR");
			sync_sb_mx.put(s_item);
		end
	endtask
	
	task async_monitor();
		$display("%t: [ASYNC-MONITOR] Starting...", $time);
		
		forever begin
          	@(vif.as);
          	//#1;
			as_item = new();
			as_sample(as_item);
			as_item.print("ASYNC-MONITOR");
			async_sb_mx.put(as_item);
		end
	endtask
	
	task run();
		$display("%t: [MONITOR] Starting...", $time);
		
		fork
			sync_monitor();
			async_monitor();
		join_none
	endtask
endclass
`endif