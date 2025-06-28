module day37();
	initial begin
		for(int i = 0; i < 5; i++) begin
			fork
				begin
					print_thread_id();
				end
			join_none
		end
		wait fork;
		$display("This is after the wait work");
	end
	
	task print_thread_id();
        #($urandom_range(5,20));
        $display("%t: Thread finished", $time);
    endtask
endmodule