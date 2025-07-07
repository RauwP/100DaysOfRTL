//day44 monitor

`ifndef DAY44_MONITOR
`define DAY44_MONITOR
`include "day44_item.sv"

class day44_monitor #(parameter NUM_PORTS = 8);
	
	day44_item #(.NUM_PORTS(NUM_PORTS)) item;
	
	virtual day44_if #(.NUM_PORTS(NUM_PORTS)) vif;
	
	mailbox sb_mx;
	
	task run();
		$display("%t: [MONITOR] Starting now...", $time);
		
		forever begin
			item = new();
			#5;
			item.req = vif.req;
			item.gnt = vif.gnt;
		
			item.print("MONITOR");
			sb_mx.put(item);
		end
    endtask
endclass

`endif