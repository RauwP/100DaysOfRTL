`ifndef DAY43_IF
`define DAY43_IF

interface day43_if(input wire clk, input wire reset);
	logic d_i, q_norst_o, q_syncrst_o, q_asyncrst_o;
	
  clocking cb @(posedge clk);
		default input #1step output #1step;
		inout d_i;
		input q_norst_o, q_syncrst_o, q_asyncrst_o;
	endclocking
  
  clocking as @(posedge reset);
    	default input #1step output #1step;
    	input q_asyncrst_o;
  endclocking
endinterface

`endif