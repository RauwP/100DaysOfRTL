//apb slave driver
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_driver extends uvm_driver#(apb_slave_item);
	`uvm_component_util(apb_slave_driver)
	
	virtual apb_slave_if vif;
	
	function new(string name="apb_slave_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(virtual apb_slave_if)::get(this,"","apb_slave_vif", vif))begin
			`uvm_fatal("DRIVER", "Couldn't get the handle to the virtual interface.")
		end
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		forever begin
			day61_item d_item;
			`uvm_info("DRIVER","Waiting for the item from the sequencer", UVM_LOW)
			seq_item_port.get_next_item(d_item);
			//TODO: Drive the item signals to the DUT
			seq_item_port.item_done();
		end
	endtask
endclass