//day61 driver
`include "uvm_macros.svh"
import uvm_pkg::*;

class day61_driver extends uvm_driver#(day61_item);

	`uvm_component_utils(day61_driver)
	
	virtual day61_if vif;
	
	function new (string name = "day61_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual day61_if)::get(this,"","day61_vif",vif)) begin
			`uvm_fatal("DRIVER","Could not get the handle to the virtual interface");
		end
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		//Always try to get a TX
		forever begin
			day61_item d_item;
			`uvm_info("DRIVER","Waiting to get the item from the sequencer",UVM_LOW)
			seq_item_port.get_next_item(d_item);
			//TODO: Drive the item to the RTL ports
			seq_item_port.item_done();
		end
	endtask
	
endclass