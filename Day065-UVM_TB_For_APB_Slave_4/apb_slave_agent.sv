//apb slave agent
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_agent extends uvm_agent;
	`uvm_component_util(apb_slave_agent)
	
	apb_slave_driver d0;
	apb_slave_monitor m0;
	uvm_sequencer#(apb_slave_item) s0;
	
	function new(string name="apb_slave_agent",uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_component phase);
		super.build_phase(phase);
		s0 = uvm_sequencer#(apb_slave_item)::type_id::create("s0",this);
		d0 = apb_slave_driver::type_id::create("d0",this);
		m0 = apb_slave_monitor::type_id::create("m0", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d0.seq_item_port.connect(s0.seq_item_export);
	endfunction
endclass