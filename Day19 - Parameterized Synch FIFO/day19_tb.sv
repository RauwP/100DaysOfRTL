`timescale 1ns/1ps
module day19_tb();
	parameter DATA_W = 16;
	parameter DEPTH = 10;
	logic clk, reset, push_i, pop_i, full_o, empty_o;
	logic [DATA_W - 1 : 0] push_data_i, pop_data_o;
	
	day19 #(.DATA_W (DATA_W), .DEPTH (DEPTH)) DAY19 (.*);
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
		$dumpfile("day19.vcd");
		$dumpvars(0, day19_tb);
		reset <= 1'b1;
		push_i <= 1'b0;
		pop_i <= 1'b0;
		push_data_i <= '0;
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;
		@(posedge clk);
		push_i <= 1'b1;
		pop_i <= 1'b1;
		push_data_i <= 16'hAB;
		@(posedge clk);
		push_data_i <= 16'hCD;
		@(posedge clk);
		push_data_i <= 16'h12;
		@(posedge clk);
		for(int i = 0; i < 64; i++) begin
			push_i <= (($urandom_range(16'hFF,0) % 2) == 1) ? 1'b1 : 1'b0;
            pop_i <= (($urandom_range(16'hFF,0) % 3) == 1) ? 1'b1 : 1'b0;
			push_data_i <= $urandom_range(16'hFF,0);
			@(posedge clk);
		end
		#1;
		$finish();
	end
endmodule