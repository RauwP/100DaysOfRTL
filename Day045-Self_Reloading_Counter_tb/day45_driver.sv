//day45 driver
`ifndef DAY45_DRIVER
`define DAY45_DRIVER
`include "day45_item.sv"

class day45_driver;
	
	day45_item item;
	
	mailbox drv_mx;
	
	virtual day45_if vif;
	
	task run();
		$display("%t: [DRIVER] Starting now...", $time);
		vif.cb.load <= 1'b0;
		forever begin
          @(posedge vif.clk);
			$display("%t: [DRIVER] Waiting for the item.", $time);
			drv_mx.get(item);
			item.print("DRIVER");
			vif.load <= item.load;
			vif.load_val <= item.load_val;
		end
	endtask
endclass
`endif