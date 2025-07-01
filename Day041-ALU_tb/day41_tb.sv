//day41 tb

class day41_item;
	
	rand bit [7:0] a, b;
	rand bit [2:0] op;
	bit [7:0] alu_o;
	
	function void print(string component);
		$display("%t: [%s] a: 0x%2x, b: 0x%2x, op: 0x%2x, alu_o: 0x%2x.", $time, component, a, b, op, alu_o);
	endfunction
endclass

class day41_sb;
	
	mailbox sb_mx;
	
	
	bit [7:0] expected_alu_o;
	
	
	task run();
		day41_item item;
		$display("%t: [SCOREBOARD] Starting now...", $time);
		
		forever begin
			sb_mx.get(item);
			item.print("SCOREBOARD");
			case(item.op)
				3'b000: expected_alu_o = item.a+item.b;
				3'b001: expected_alu_o = item.a-item.b;
				3'b010: expected_alu_o = item.a[7:0] << item.b[2:0];
				3'b011: expected_alu_o = item.a[7:0] >> item.b[2:0];
				3'b100: expected_alu_o = item.a[7:0] & item.b[7:0];
				3'b101: expected_alu_o = item.a[7:0] | item.b[7:0];
				3'b110: expected_alu_o = item.a[7:0] ^ item.b[7:0];
				3'b111: expected_alu_o = {7'h0,(item.a == item.b)};
			endcase
			if(item.alu_o !== expected_alu_o) $fatal(1,"%t: [SCOREBOARD] Output doesnt match the expected output. Expected: 0x%2x, Got: 0x%2x.", $time, expected_alu_o, item.alu_o);
		end
	endtask
endclass

class day41_monitor;
	
	day41_item item;
	virtual day41_if vif;
	mailbox sb_mx;
	
	task run();
		$display("%t: [MONITOR] starting now...", $time);
		
		forever begin
			item = new;
			
			#6;
			
			item.a = vif.a;
			item.b = vif.b;
			item.op = vif.op;
			item.alu_o = vif.alu_o;
			item.print("MONITOR");
			sb_mx.put(item);
		end
	endtask
endclass

class day41_driver;
	
	virtual day41_if vif;
	
	mailbox drv_mx;
	
	task run();
		$display("%t: [DRIVER] Starting now...", $time);
		
		forever begin
			day41_item item;
			
			$display("%t: [DRIVER] Waiting for the item.", $time);
			drv_mx.get(item);
			item.print("DRIVER");
			vif.a <= item.a;
			vif.b <= item.b;
			vif.op <= item.op;
			#5;
		end
	endtask
endclass

class day41_env;

	day41_driver	drv;
	day41_monitor	mon;
	day41_sb		sb;
	
	mailbox sb_mx;
	
	virtual day41_if vif;
	
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

class day41_test;
	
	day41_env env;
	mailbox drv_mx;
	
	function new();
		env = new;
		drv_mx = new;
	endfunction
	
	task gen_stimulus();
		
		day41_item item;
		
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

module day41_tb();
	day41_if intf();
	
	day4 Day4(
		.a_i(intf.a),
		.b_i(intf.b),
		.op_i(intf.op),
		.alu_o(intf.alu_o)
	);
	
	day41_test test;
	
	initial begin
		$dumpfile("day41.vcd");
		$dumpvars(0, day41_tb);
		
		test = new;
		test.env.vif = intf;
		test.run();
		$finish();
	end
endmodule	