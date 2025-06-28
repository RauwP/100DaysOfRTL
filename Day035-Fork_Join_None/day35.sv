module day35();

	initial begin
		$display("%t: Hello, I am the parent!",$time);
		fork
			
			begin
				#35;//wait 35ns
				$display("%t: Child 1 is finished! - I am the third and I presist!", $time);
			end
			
			begin
				#20;//wait 20ns
				$display("%t: Child 2 is finished! - I am the second and I presist!", $time);
			end
			
			begin
				#10;//wait 10ns
				$display("%t: Child 3 is finished! - I am the first, and I presist!", $time);
			end
		join_none//parent waits for no one.
		$display("%t: Parent is finished!",$time);
	end
endmodule