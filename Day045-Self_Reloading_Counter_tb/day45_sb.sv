//day45 scoreboard
`ifndef DAY45_SB
`define DAY45_SB
`include "day45_item.sv"

class day45_sb;
	
	day45_item item;
	
	virtual day45_if vif;
	
	mailbox sb_mx;
	
	logic [3:0] curr_count = 0, nxt_count = 0, load_val = 0;
	
	task run();
		@(negedge vif.reset);
		$display("%t: [SB] Starting now...", $time);
		
		forever begin
			@(posedge vif.clk);
          	curr_count = nxt_count;
			sb_mx.get(item);
			item.print("SB-MON");
			
          if(item.count !== curr_count) $fatal(1, "%t: [SB] Output mismatch. Expected: 0x%4x. Got: 0x%4x.", $time, item.count, curr_count);
			if(vif.load) load_val = item.load_val;
          if((curr_count == 4'hF) | vif.load)
				nxt_count = load_val;
			else
				nxt_count = curr_count + 4'h1;
          if(vif.reset) nxt_count = 1'b0;
		end
	endtask
endclass
`endif