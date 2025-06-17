//Day 24 virtual interface
class day24;
	virtual day23 vif;
	task run_test();
		vif.psel <= 1'b0;
		vif.penable <= 1'b0;
		
		$display("Starting stim now...");
		repeat(5) @(posedge vif.clk);
		
		forever begin
			vif.psel <= 1'b1; //setup
			@(posedge vif.clk);
			vif.penable <= 1'b1; //access
			vif.paddr[9:0] <= 10'h3EC;
			vif.pwrite <= $urandom_range(0,10) % 2;
			vif.pwdata <= $urandom_range(0, 1023);
			wait(vif.pready);
			@(posedge vif.clk);
			vif.psel <= 1'b0;
			vif.penable <= 1'b0;
			repeat(2) @(posedge vif.clk);
		end
	endtask
endclass

module day24_tb();
	logic clk,reset;
	day24 DAY24;
	
	day23 day23_if(.clk(clk), .reset(reset));
	
	initial begin
		DAY24 = new();
		DAY24.vif = day23_if;
		DAY24.run_test();
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
		$finish();
	end
	
	initial begin
		$dumpfile("day24.vcd");
		$dumpvars(0, day24_tb);
	end
endmodule