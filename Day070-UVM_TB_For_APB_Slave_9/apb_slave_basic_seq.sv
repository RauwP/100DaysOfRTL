//apb slave basic sequence
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_basic_seq extends uvm_sequence;
	`uvm_object_utils(apb_slave_basic_seq)
	
	rand int num_txn;
	
	function new(string name="apb_slave_basic_seq");
		super.new(name);
	endfunction
	
	constraint apb_num_txn {num_txn inside {[20:100]};}
	
	virtual task body();
		string tx;
		
		for(int i=0; i<num_txn;i++)begin
			apb_slave_item item = apb_slave_item::type_id::create("seq_item");	
          
          	`uvm_info("SEQUENCE", "Starting new APB Slave item.", UVM_LOW)
		
			start_item(item);
          	void'(item.randomize());
			tx = item.tx2string();
			`uvm_info("SEQUENCE", $sformatf("Gen a new APB Slave item:\n%s", tx), UVM_LOW)
			finish_item(item);
		end
		`uvm_info("SEQUENCE","Finished sending APB Slave items.", UVM_LOW)
	endtask
endclass