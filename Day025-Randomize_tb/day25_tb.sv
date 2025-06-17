class day25;
	
	virtual day23 vif;
	
	logic [31:0] paddr, pwdata;
	logic pwrite;
	
	logic [31:0] addr_q[$];
	
	task run_test();
		vif.psel <= 1'b0;
		vif.penable <= 1'b0;
		$display("starting stim now..");
		repeat(5) @(posedge vif.clk);
		
		forever begin
			void'(randomize(pwrite));
			void'(randomize(pwdata));
			void'(randomize(paddr));
			
			if(addr_q.size() == 0) begin
				pwrite = 1;
			end else begin
				addr_q.shuffle();
				if(~pwrite) begin
					paddr = addr_q[0];
				end
			end
			
			addr_q.push_back(paddr);
			vif.psel <= 1'b1;
			@(posedge vif.clk);
			vif.penable <= 1'b1;
			vif.paddr[9:0] <= paddr[9:0];
			vif.pwrite <= pwrite;
			vif.pwdata <= pwdata;
			wait(vif.pready);
			@(posedge vif.clk);
			vif.psel <= 1'b0;
			vif.penable <= 1'b0;
			repeat(2) @(posedge vif.clk);
		end
	endtask
endclass

module day25_tb();
	logic clk,reset;
	day25 DAY25;
	
	day23 day23_if(.clk(clk), .reset(reset));
	
	initial begin
		DAY25 = new();
		DAY25.vif = day23_if;
		DAY25.run_test();
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
		$dumpfile("day25.vcd");
		$dumpvars(0, day25_tb);
	end
endmodule