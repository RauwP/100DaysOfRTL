//day32_tb
//Day 24 virtual interface
class day24;
	virtual day23 vif;
	task run_test();
		vif.cb.psel <= 1'b0;
		vif.cb.penable <= 1'b0;
		
		$display("Starting stim now...");
		repeat(5) @(posedge vif.clk);
		
		forever begin
			vif.cb.psel <= 1'b1; //setup
			@(posedge vif.clk);
			vif.cb.penable <= 1'b1; //access
			vif.cb.paddr[9:0] <= 10'h3EC;
			vif.cb.pwrite <= $urandom_range(0,10) % 2;
			vif.cb.pwdata <= $urandom_range(0, 1023);
			wait(vif.cb.pready);
			@(posedge vif.clk);
			vif.cb.psel <= 1'b0;
			vif.cb.penable <= 1'b0;
			repeat(2) @(posedge vif.clk);
		end
	endtask
	
	task run_check();
		bit[31:0] last_write;
		bit first_write_complete = 0;
		
		$display("Starting check now...");
		
		forever begin
			if(vif.penable & vif.cb.pready & vif.pwrite) begin
				first_write_complete = 1;
				last_write = vif.pwdata;
			end
			if(first_write_complete && (vif.penable & vif.cb.pready & ~vif.pwrite) && (last_write !== vif.cb.prdata)) $display("%t Last write doesnt match. Expected: 0x%8x Got 0x%8x.", $time, last_write, vif.cb.prdata);
			@(posedge vif.clk);
		end
	endtask
endclass

module day32_tb();
	logic clk,reset;
	day24 DAY24;
	
	day23 day23_if(.clk(clk), .reset(reset));
	
	initial begin
		DAY24 = new();
		DAY24.vif = day23_if;
		fork
			DAY24.run_test();
			DAY24.run_check();
		join
	end
	
	day18 apb_slave(.clk(clk), .reset(reset), .apb_if(day23_if.apb_slave));
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
		reset <= 1'b1;
		repeat(3) @(posedge clk);
		reset <= 1'b0;
		repeat(150) @(posedge clk);
		#1;
		$display("Tests Complete!");
		$finish();
	end
	
	initial begin
		$dumpfile("day32.vcd");
		$dumpvars(0, day32_tb);
	end
endmodule