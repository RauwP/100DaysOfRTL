`timescale 1ns/1ps
module day20_tb();
	logic clk, reset, read_i, write_i, rd_valid_o;
	logic[31:0] rd_data_o;
  
	day20 DAY20 (.*);
  
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
		$dumpfile("day20.vcd");
		$dumpvars(0, day20_tb);
		reset     <= 1'b1;
		read_i    <= 1'b0;
		write_i   <= 1'b0;
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;
		@(posedge clk);
		for (int i=0; i<512; i++) begin
			read_i    <= $urandom_range(25,50)%2;
			write_i   <= $urandom_range(0, 25)%2;
			@(posedge clk);
		end
	#1;
    $finish();
  end
 endmodule