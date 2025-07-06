//day44 driver
`ifndef DAY44_DRIVER
`define DAY44_DRIVER
`include "day44_item.sv"

class day44_driver #(parameter NUM_PORTS = 8);
	
	day44_item #(.NUM_PORTS(NUM_PORTS)) item;
	
	virtual day44_if #(.NUM_PORTS(NUM_PORTS)) vif;
	
	mailbox drv_mx;
	
	task run();
		$display("%t: [DRIVER] Starting now...", $time);
		
		forever begin
			$display("%t: [DRIVER] Waiting for the item.", $time);
			drv_mx.get(item);
			item.print("DRIVER");
			vif.req <= item.req;
			#5;
		end
	endtask
endclass

`endif