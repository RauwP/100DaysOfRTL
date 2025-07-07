//day45 item

`ifndef DAY45_ITEM
`define DAY45_ITEM

class day45_item;
	rand bit load;
	rand bit[3:0] load_val;
	bit [3:0] count;
	
  constraint c_load_frequecy { load dist {1 := 20, 0 := 80};}
	
	function void print(string component);
		$display("%t: [%s] load: %b, load_val: 0x%4x, count: 0x%4x.", $time, component, load, load_val, count);
	endfunction
endclass
`endif