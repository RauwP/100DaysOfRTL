//day33
module day33();

	initial begin
		$display("%t: Hello, I am the parent!",$time);
		fork
			
			begin
				#35;//wait 35ns
				$display("%t: Child 1 is finished!", $time);
			end
			
			begin
				#20;//wait 20ns
				$display("%t: Child 2 is finished!", $time);
			end
			
			begin
				#10;//wait 10ns
				$display("%t: Child 3 is finished!", $time);
			end
		join//parent waits for all child threads to finish (The last one is child 1 it finishes after 35ns).
		$display("%t: Parent is finished!",$time);
	end
endmodule