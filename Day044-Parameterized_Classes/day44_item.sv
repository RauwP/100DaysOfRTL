//day44_item
`ifndef DAY44_ITEM
`define DAY44_ITEM

class day44_item #(parameter NUM_PORTS = 8);
	rand bit [NUM_PORTS-1:0] req;
	bit [NUM_PORTS-1:0] gnt;
	
	function void print(string component);
		$display("%t: [%s] req: %b, gnt: %b.", $time, component, req, gnt);
	endfunction
endclass

`endif