`ifndef DAY43_DRIVER
`define DAY43_DRIVER

`include "day43_item.sv"

class day43_driver;

	virtual day43_if vif;
	
	day43_item s_item, as_item;
	
	function void sample_no_d(day43_item item);
		//item.d = vif.cb.d;
		item.reset = vif.reset;
		item.q_norst = vif.cb.q_norst_o;
		item.q_syncrst = vif.cb.q_syncrst_o;
		item.q_asyncrst = vif.cb.q_asyncrst_o;
	endfunction
	
	function void sample_no_reset(day43_item item);
		item.d = vif.cb.d_i;
		//item.reset = vif.reset;
		item.q_norst = vif.cb.q_norst_o;
		item.q_syncrst = vif.cb.q_syncrst_o;
		item.q_asyncrst = vif.as.q_asyncrst_o;
	endfunction
	
	task sync_drv();
		$display("%t: [SYNC_DRIVER] Starting...", $time);
		s_item = new();
		forever begin
			@(vif.cb)
			void'(s_item.randomize());
			vif.cb.d_i <= s_item.d;
			sample_no_d(s_item);
			s_item.print("SYNC-DRIVER");
		end
	endtask
	
	/*task async_drv();
		$display("%t: [ASYNC-DRIVER] Starting...", $time);
		as_item = new();
		forever begin
          	#($urandom_range(100,300));
			as_item.reset = 1'b1;
			vif.reset <= 1'b1;
          	@(vif.as);
          	sample_no_reset(as_item);
			as_item.print("ASYNC-DRIVER");
			#($urandom_range(1,50));
			as_item.reset = 1'b0;
			vif.reset <= 1'b0;
			sample_no_reset(as_item);
			as_item.print("ASYNC-DRIVER");
		end
	endtask*/
	
	task run();
		$display("%t: [DRIVER] Starting...", $time);
		//$display("%t: [DRIVER] Initial reset starting...", $time);
		//vif.reset <= 1'b1;
		//vif.cb.d_i <= 1'b0;
		//#20;
		//vif.reset <= 1'b0;
		//$display("%t: [DRIVER] Initial reset finished.", $time);
		//fork
			sync_drv();
			//async_drv();
		//join_none
	endtask
endclass
`endif