//day42 tb

class day42_item;
	
	rand bit [3:0] req;
	bit [3:0] gnt;
	
	function void print(string component);
		$display("%t: [%s] req: %b, gnt: %b.", $time, component, req, gnt);
	endfunction
endclass

class day42_sb;
	
	mailbox sb_mx;
	
	
	bit [3:0] expected_gnt;
	
	function logic [3:0] gnt(logic [3:0] req);
		gnt = 4'h0;
		for(int i = 0 ; i < 4 ; i++) begin
			if(req[i]) begin
				gnt = 4'(1<<i);
				break;
			end
		end
		return gnt;
	endfunction
	
	
	task run();
		day42_item item;
		$display("%t: [SCOREBOARD] Starting now...", $time);
		
		forever begin
			sb_mx.get(item);
			item.print("SCOREBOARD");
			expected_gnt = gnt(item.req);
			if(item.gnt !== expected_gnt) $fatal(1, "%t: Output doesn't match! Expected: %b, Got: %b.", $time, item.gnt, expected_gnt);
		end
	endtask
endclass

class day42_monitor;
	
	day42_item item;
	virtual day42_if vif;
	mailbox sb_mx;
	
	task run();
		$display("%t: [MONITOR] starting now...", $time);
		
		forever begin
			item = new;
			
			#6;
			
			item.req = vif.req;
			item.gnt = vif.gnt;
			item.print("MONITOR");
			sb_mx.put(item);
		end
	endtask
endclass

class day42_driver;
	
	virtual day42_if vif;
	
	mailbox drv_mx;
	
	task run();
		$display("%t: [DRIVER] Starting now...", $time);
		
		forever begin
			day42_item item;
			
			$display("%t: [DRIVER] Waiting for the item.", $time);
			drv_mx.get(item);
			item.print("DRIVER");
			vif.req <= item.req;
			#5;
		end
	endtask
endclass

class day42_env;

	day42_driver	drv;
	day42_monitor	mon;
	day42_sb		sb;
	
	mailbox sb_mx;
	
	virtual day42_if vif;
	
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

class day42_test;
	
	day42_env env;
	mailbox drv_mx;
	
	function new();
		env = new;
		drv_mx = new;
	endfunction
	
	task gen_stimulus();
		
		day42_item item;
		
		for(int i=0 ; i<512; i++) begin
			$display("%t: [TEST] Starting stimulus...", $time);
			item = new;
			void'(item.randomize());
			drv_mx.put(item);
			#7;
		end
	endtask
	
	task run();
		env.drv.drv_mx = drv_mx;
		fork
			env.run();
		join_none
		gen_stimulus();
	endtask
endclass

module day42_tb();
	day42_if intf();
	
	day14 Day14(
		.req_i(intf.req),
		.gnt_o(intf.gnt)
	);
	
	day42_test test;
	
	initial begin
		$dumpfile("day42.vcd");
		$dumpvars(0, day42_tb);
		
		test = new;
		test.env.vif = intf;
		test.run();
		$finish();
	end
endmodule	