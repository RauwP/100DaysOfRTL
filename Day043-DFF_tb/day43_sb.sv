`ifndef DAY43_SB
`define DAY43_SB

`include "day43_item.sv"

class day43_sb;

	virtual day43_if vif;
	
	mailbox async_sb_mx, sync_sb_mx;
	
	day43_item s_current_item, s_prev_item, as_current_item;
	
	logic as_exp_q_asyncrst = 0, as_exp_q_norst = 0, as_exp_q_syncrst = 0, s_exp_q_norst = 0, s_exp_q_syncrst = 0, s_exp_q_asyncrst = 0;
		
  	logic rst_between_clks = 0;
  task rst_btwn_clks();
    forever begin
      @(posedge vif.reset);
      rst_between_clks <= 1'b1;
    end
  endtask
	task async_sb();
		$display("%t: [ASYNC-SB] Starting...", $time);
		
		forever begin
          @(vif.as);
			async_sb_mx.get(as_current_item);
			as_current_item.print("ASYNC-SB");
          	if(s_prev_item !== null) begin
				as_exp_q_norst = s_prev_item.q_norst;
				as_exp_q_syncrst = s_prev_item.q_syncrst;
              	//as_exp_q_asyncrst = vif.q_asyncrst_o;
            end
          if(as_exp_q_norst !== as_current_item.q_norst) $fatal(1, "[ASYNC-SB] %t: No Reset output mismatch!, Expected: %b, Got: %b.", $time, as_exp_q_norst, as_current_item.q_norst);
          if(as_exp_q_syncrst !== as_current_item.q_syncrst) $fatal(1, "[ASYNC-SB] %t: Sync Reset output mismatch!, Expected: %b, Got: %b.", $time, as_exp_q_syncrst, as_current_item.q_syncrst);
          if(1'b0 !== as_current_item.q_asyncrst) $fatal(1, "[ASYNC-SB] %t: Async Reset Error! didn't get 0!.", $time);
		end
	endtask
	
	task sync_sb();
		$display("%t: [SYNC-SB] Starting...", $time);
		
		forever begin
          if(s_current_item !== null) s_prev_item = s_current_item;
          	@(vif.cb);
			sync_sb_mx.get(s_current_item);
			s_current_item.print("SYNC-SB-CURR");
          	if(s_prev_item != null) begin
              	s_prev_item.print("SYNC-SB-PREV");
				s_exp_q_norst = s_prev_item.d;
              s_exp_q_syncrst = s_prev_item.reset ? 1'b0 : s_prev_item.d;
              s_exp_q_asyncrst = (rst_between_clks|vif.reset | s_prev_item.reset) ? 1'b0 : s_prev_item.d;
            end
          	else begin
            	s_exp_q_norst = 0;
				s_exp_q_syncrst = 0;
				s_exp_q_asyncrst = 0;
            end
			if(s_exp_q_norst !== s_current_item.q_norst) $fatal(1, "[SYNC-SB] %t: No Reset output mismatch!, Expected: %b, Got: %b.", $time, s_exp_q_norst, s_current_item.q_norst);
          if(s_exp_q_syncrst !== s_current_item.q_syncrst)begin #5; $fatal(1, "[SYNC-SB] %t: Sync Reset output mismatch!, Expected: %b, Got: %b.", $time, s_exp_q_syncrst, s_current_item.q_syncrst); end
          if(s_exp_q_asyncrst !== s_current_item.q_asyncrst) $fatal(1, "[SYNC-SB] %t: Async Reset output mismatch!, Expected: %b, Got: %b.", $time, s_exp_q_asyncrst, s_current_item.q_asyncrst);
          rst_between_clks = 1'b0;
		end
	endtask
	
	task run();
      $display("%t: [SB] Starting...", $time);
		
		fork
			sync_sb();
			async_sb();
          rst_btwn_clks();
		join_none
	endtask
endclass
`endif