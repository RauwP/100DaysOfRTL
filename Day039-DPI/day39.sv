module day39();
	import "DPI-C" function int factorial(int);
	
	initial begin
		for (int i = 1 ; i < 11 ; i++) $display("Factorial of %d is %d.", i, factorial(i));
	end
endmodule