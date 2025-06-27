module day34();

	initial begin
		$display("%t: Hello, I am the parent!",$time);
		fork
			
			begin
				#35;//wait 35ns
				$display("%t: Child 1 is finished! - I am presistent!", $time);
			end
			
			begin
				#20;//wait 20ns
				$display("%t: Child 2 is finished! - I am presistent!", $time);
			end
			
			begin
				#10;//wait 10ns
				$display("%t: Child 3 is finished! - prints in the runtime of the parent and tells it to finish!", $time);
			end
		join_any//parent waits for one of the child threads to finish (The first one is child 3 it finishes after 10ns).
		$display("%t: Parent is finished!",$time);
	end
endmodule