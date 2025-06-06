`timescale 1ns/1ps
module day18_tb();

	logic clk, reset,psel_i, penable_i, pwrite_i, pready_o;
	logic [9:0] paddr_i;
	logic [31:0] pwdata_i, prdata_o;
	logic [9:0] [9:0] rand_addr_list;	
	
	day18 DAY18(.*);
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
		$dumpfile("day18.vcd");
		$dumpvars(0, day18_tb);

		reset <= 1'b1;
		psel_i <= 1'b0;
		penable_i <= 1'b0;
		@(posedge clk);
		reset <= 1'b0;
		@(posedge clk);
		for (int i = 0; i < 10 ; i++) begin
			psel_i <= 1'b1;
			@(posedge clk);
			penable_i <= 1'b1;
			paddr_i <= $urandom_range(0, 10'h3FF);
			pwdata_i  <= $urandom_range(0, 16'hFFF);
			pwrite_i <= 1'b1;
			while (~(psel_i & penable_i & pready_o)) @(posedge clk);
			psel_i <= 1'b0;
			penable_i <= 1'b0;
			rand_addr_list[i] <= paddr_i;
			@(posedge clk);
		end
		
		for (int i = 0; i < 10; i++) begin
			psel_i <= 1'b1;
			@(posedge clk);
			penable_i <= 1'b1;
			paddr_i <= rand_addr_list[i];
			pwrite_i <= 1'b0; //read
			pwdata_i <= $urandom_range(0, 16'hFFF);
			while (~(psel_i & penable_i & pready_o)) @(posedge clk);
			psel_i <= 1'b0;
			penable_i <= 1'b0;
			@(posedge clk);
		end
		#1;
		$finish();
	end
endmodule
			