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
  	
  	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_analysis_imp = new("apb_slave_imp", this);
    endfunction
  
	virtual function write(apb_slave_item item);
      	logic[31:0] mem_data;
      	`uvm_info("SCOREBOARD","Got a new tx", UVM_LOW)
		//write data to mem on write
      	if(item.psel & item.pready & item.penable & item.pwrite) begin
        	mem_data = mem[item.paddr]+1;
          	if(item.pwdata !== mem_data) `uvm_fatal(get_type_name(), $sformatf("Read data doesn't match expected data. Data Read: 0x%8x, Expected: 0x%8x.", item.pwdata, mem_data))
      	end
		//on read, store the read data to be compared on the next write
		if(item.psel & item.pready & item.penable & ~item.pwrite) begin
          `uvm_info(get_type_name, $sformatf("Storing the read data (%x) into mem.", item.prdata), UVM_LOW)
          mem[item.paddr] = item.prdata;
        end	
	endfunction
endclass