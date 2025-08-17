//apb slave scoreboard
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(apb_slave_scoreboard)
	
	bit[31:0] mem [bit[9:0]];
	uvm_analysis_imp#(apb_slave_item,apb_slave_scoreboard) m_analysis_imp;
	
	function new(string name="apb_slave_scoreboard",uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void write(apb_slave_item item);
		logic[31:0] mem_data;
		//write data to mem on write
		if(item.psel & item.pready & item.penable & item.pwrite) mem[item.addr] = item.pwdata;
		//read data from mem on read, throw out error if data mismatch
		if(item.psel & item.pready & item.penable & ~item.pwrite) begin
			mem_data = mem[item.paddr];
			if(item.prdata !== mem_data) `uvm_fatal(get_type_name(), $sformatf("Data mismatch between expected and read. Expected:0x%8x, Read:0x%8x.",item.prdata,mem_data))
		end
	endfunction
endclass