`include "day43_test.sv"
//`include "day43_item.sv"
day43_item as_item;
module day43_tb();
	logic clk, reset;
  day43_if intf(clk, reset);//, reset);
	day43_test test;
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	day2 DAY2(
				.clk(clk),
      .reset(intf.reset),
				.d_i(intf.d_i),
				.q_norst_o(intf.q_norst_o),
				.q_syncrst_o(intf.q_syncrst_o),
				.q_asyncrst_o(intf.q_asyncrst_o)
			);
  function void sample_no_reset(day43_item item);
	item.d = intf.cb.d_i;
	//item.reset = vif.reset;
	item.q_norst = intf.cb.q_norst_o;
	item.q_syncrst = intf.cb.q_syncrst_o;
	item.q_asyncrst = intf.q_asyncrst_o;
  endfunction
  task asyc_run();
    $display("%t: [ASYNC-DRIVER] Starting...", $time);
	as_item = new();
		forever begin
          	#($urandom_range(100,300));
			reset = 1'b1;
          	as_item.reset = 1'b1;
          @(intf.as);
          	sample_no_reset(as_item);
			as_item.print("ASYNC-DRIVER");
			#($urandom_range(1,50));
			as_item.reset = 1'b0;
			reset <= 1'b0;
          @(negedge reset);
			sample_no_reset(as_item);
			as_item.print("ASYNC-DRIVER");
		end
  endtask
	initial begin
		$dumpfile("day43.vcd");
		$dumpvars(0, day43_tb);		
		test = new();
		test.vif = intf;
      	reset <= 1'b1;
      	intf.d_i <= 1'b0;
      	#20;
      	reset <= 1'b0;
		fork
      		test.run();
          	asyc_run();
        join_none
		#2000;
		$display("%t: [TB] Tests Done!", $time);
		$finish();
	end
endmodule