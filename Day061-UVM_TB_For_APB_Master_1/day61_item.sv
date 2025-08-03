//day61 item
`include "uvm_macros.svh"
import uvm_pkg::*;

class day61_item extends uvm_sequence_item;
	
	rand bit 		pready;
	rand bit[31:0] 	prdata;
	
	`uvm_object_utils(day61_item)
	
	function new(string name = "day61_item");
		super.new(name);
	endfunction
	
	virtual function string tx2string();
		string tx;
		tx = $sformatf("pready=%b, pready=0x%8x",pready,prdata);
		return tx;
	endfunction
endclass