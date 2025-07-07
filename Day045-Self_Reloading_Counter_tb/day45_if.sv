//day45 interface

interface day45_if(input wire clk, input wire reset);
  logic load;
  logic	[3:0]	count, load_val;
  
  clocking cb@(posedge clk);
	output #1step load;
	output #1step load_val;
	input  #0 count;
  endclocking
 endinterface