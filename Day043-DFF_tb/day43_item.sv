`ifndef DAY43_ITEM
`define DAY43_ITEM

class day43_item;
	rand bit d;
	bit reset, q_norst, q_syncrst, q_asyncrst;
	
	function void print(string component);
      $display("%t: [%s],\t\t d: %b, reset: %b. Outputs: Q[No Reset]: %b, Q[Sync Reset]: %b, Q[Async Reset]: %b.",
		$time, component, d, reset, q_norst, q_syncrst, q_asyncrst);
	endfunction
endclass

`endif