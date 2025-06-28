module day38();
	initial begin
		for(int i = 0; i < 5; i++) begin
			fork
				automatic int j = i;
				begin
					print_thread_id(j);
				end
			join_none
		end
		wait fork;
		$display("This is after the wait work");
	end
	
	task automatic print_thread_id(int thread_id);
        #($urandom_range(5,20));
        $display("%t: Thread %d finished", $time, thread_id);
    endtask
endmodule