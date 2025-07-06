//day44_sb
`ifndef DAY44_SB
`define DAY44_SB
`include "day44_item.sv"
class day44_sb #(parameter NUM_PORTS = 8);
	
	mailbox sb_mx, drv_mx;
	
	//logic exp_gnt[NUM_PORTS-1:0];
	
	logic [NUM_PORTS-1:0] exp_gnt;
	
	function logic [NUM_PORTS-1:0] gnt(logic [NUM_PORTS-1:0] req);
		gnt = '0;
		for(int i = 0 ; i < NUM_PORTS ; i++) begin
			if(req[i]) begin
				gnt = NUM_PORTS'(1<<i);
				break;
			end
		end
		return gnt;
	endfunction
	
	
	task run();
	
		day44_item #(.NUM_PORTS(NUM_PORTS)) mon_item;
		day44_item #(.NUM_PORTS(NUM_PORTS)) drv_item;

		$display("%t: [SCOREBOARD] Starting now...", $time);
		
		forever begin
			
			fork
				sb_mx.get(mon_item);
				drv_mx.get(drv_item);
			join
			mon_item.print("SB");
			drv_item.print("DRIVER");
			exp_gnt = gnt(drv_item.req);
          if(mon_item.gnt !== exp_gnt) $fatal(1, "%t: [SB] Mismatched output! Expected: %b, Got: %b.", $time, mon_item.gnt, exp_gnt);
		end
	endtask
endclass
`endif