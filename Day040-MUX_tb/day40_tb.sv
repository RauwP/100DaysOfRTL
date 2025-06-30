//day40 tb

class day40_item;
	
	rand bit [7:0] a, b;
	rand bit sel;
	bit [7:0] y;
	
	function void print(string component);
		$display("%t: [%s] a: 0x%2x, b: 0x%2x, sel: %b, y: 0x%2x.", $time, component, a, b, sel, y);
	endfunction
endclass

class day40_sb;
	
	mailbox sb_mx;
	
	task run();
		day40_item item;
		$display("%t: [SCOREBOARD] Starting now...", $time);
		
		forever begin
			sb_mx.get(item);
			item.print("SCOREBOARD");
			
			if(item.sel) begin
				if(item.a !== item.y) $fatal(1,"%t: [SCOREBOARD] Output doesnt match the expected output. Expected: 0x%2x, Got: 0x%2x.", $time, item.a, item.y);
			end
			else begin
				if(item.b !== item.y) $fatal(1,"%t: [SCOREBOARD] Output doesnt match the expected output. Expected: 0x%2x, Got: 0x%2x.", $time, item.b, item.y);				
			end
		end
	endtask
endclass

class day40_monitor;
	
	day40_item item;
	virtual day40_if vif;
	mailbox sb_mx;
	
	task run();
		$display("%t: [MONITOR] starting now...", $time);
		
		forever begin
			item = new;
			
			#6;
			
			item.a = vif.a;
			item.b = vif.b;
			item.sel = vif.sel;
			item.y = vif.y;
			item.print("MONITOR");
			sb_mx.put(item);
		end
	endtask
endclass

class day40_driver;
	
	virtual day40_if vif;
	
	mailbox drv_mx;
	
	task run();
		$display("%t: [DRIVER] Starting now...", $time);
		
		forever begin
			day40_item item;
			
			$display("%t: [DRIVER] Waiting for the item.", $time);
			drv_mx.get(item);
			item.print("DRIVER");
			vif.a <= item.a;
			vif.b <= item.b;
			vif.sel <= item.sel;
			#5;
		end
	endtask
endclass

class day40_env;

	day40_driver	drv;
	day40_monitor	mon;
	day40_sb		sb;
	
	mailbox sb_mx;
	
	virtual day40_if vif;
	
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

class day40_test;
	
	day40_env env;
	mailbox drv_mx;
	
	function new();
		env = new;
		drv_mx = new;
	endfunction
	
	task gen_stimulus();
		
		day40_item item;
		
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

module day40_tb();
	day40_if intf();
	
	day1 Day1(
		.a_i(intf.a),
		.b_i(intf.b),
		.sel_i(intf.sel),
		.y_o(intf.y)
	);
	
	day40_test test;
	
	initial begin
		$dumpfile("day40.vcd");
		$dumpvars(0, day40_tb);
		
		test = new;
		test.env.vif = intf;
		test.run();
		$finish();
	end
endmodule	