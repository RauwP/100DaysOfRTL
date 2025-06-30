//day40

interface day40_if();
	logic [7:0] a,b,y;
	logic sel;
endinterface

module day1(
	input		wire		[7:0]		a_i,
	input		wire		[7:0]		b_i,
	input		wire					sel_i,
	output		wire		[7:0]		y_o
	);
	
	assign y_o = sel_i ? a_i : b_i;
endmodule