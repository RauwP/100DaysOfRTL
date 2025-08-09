//apb slave item
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_item extends uvm_sequence_item;
	bit psel, penable, pwrite;
	rand bit pready;
	bit [9:0] paddr;
	bit [31:0] pwdata;
	rand bit [31:0] prdata;
	
	`uvm_object_utils(apb_slave_item)
	
	function new(string name = "apb_slave_item");
		super.new(name);
	endfunction
	
	virtual function string tx2string();
		string tx;
		tx = $sformatf("pready=%b, prdata=0x%8x", pready, prdata);
		return tx;
	endfunction
endclass
