//day45 monitor
`ifndef DAY45_MONITOR
`define DAY45_MONITOR
`include "day45_item.sv"

class day45_monitor;
	
	day45_item item;
	
	virtual day45_if vif;
	
	mailbox sb_mx;
	
	task run();
		@(negedge vif.reset);
		$display("%t: [MONITOR] Starting now...", $time);
		
		forever begin
			item = new;
          @(posedge vif.clk);
			item.load  = vif.load;
			item.load_val = vif.load_val;
			item.count = vif.count;
			item.print("MONITOR");
			sb_mx.put(item);
		end
	endtask
endclass
`endif