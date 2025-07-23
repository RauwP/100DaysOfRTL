//day58 - UVM driver communications
`include "uvm_macros.svh"
import uvm_pkg::*;

class day58_item extends uvm_sequence_item;
	`uvm_object_utils(day58_item);
	rand int data;
	
	function new(string name="day58_item");
		super.new(name);
	endfunction
endclass

class day58_seq extends uvm_sequence #(day58_item);
	`uvm_object_utils(day58_seq)
	
	function new(string name="day58_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		for(int i=0; i<50; i++) begin
			day58_item item = day58_item::type_id::create("rand_item");
      		item.randomize();
			`uvm_info("SEQ","Starting to send item", UVM_LOW);
			start_item(item);
			finish_item(item);
			`uvm_info("SEQ","After finish_item()", UVM_LOW);
		end
    endtask   
endclass

class day58_drv extends uvm_driver #(day58_item);
	`uvm_component_utils(day58_drv);
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin	
			`uvm_info("DRV", "Getting the next item from the sequencer.", UVM_LOW);
			seq_item_port.get_next_item(req);
      		`uvm_info("DRV", $sformatf("Got the following data: 0x%8x.", req.data), UVM_LOW);
			#5;
      		seq_item_port.item_done();
        end
	endtask
endclass

class day58_test extends uvm_test;
	`uvm_component_utils(day58_test)
	
	day58_drv d_drv;
	day58_seq d_seq;
	uvm_sequencer #(day58_item) d_seqr;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		d_drv = day58_drv::type_id::create("day58_drv",this);
		d_seqr = uvm_sequencer#(day58_item)::type_id::create("day58_seqr", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d_drv.seq_item_port.connect(d_seqr.seq_item_export);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
      	d_seq = day58_seq::type_id::create("d_seq");
		d_seq.start(d_seqr);
		#300;
      	phase.drop_objection(this);
	endtask
endclass

module day58_tb;
	initial begin
		run_test("day58_test");
	end
endmodule