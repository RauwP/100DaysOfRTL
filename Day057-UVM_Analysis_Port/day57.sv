//day57 - UVM Analysis Port
`include "uvm_macros.svh"
import uvm_pkg::*;

class sender extends uvm_component;
	`uvm_component_utils(sender);
	
	uvm_analysis_port #(int) sender_ap;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sender_ap = new("analysis_port", this);
	endfunction
	
	virtual task run_phase (uvm_phase phase);
		int rand_num = 0; //keep sending numbers until 42 arrives or 50 sends are made
		
		for(int i=0;(i<50) && (rand_num !== 42);i++) begin
			rand_num = $urandom_range(0,100);
			sender_ap.write(rand_num);
		end
	endtask
endclass

class subscriber #(type T = int) extends uvm_subscriber #(T);
	`uvm_component_utils(subscriber);
	int n;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(int)::get(this, "", "sub_id", n)) begin
           `uvm_fatal("NO_ID", "No subscriber ID found in config_db")
        end
	endfunction
	
	virtual function void write(T t);
		string sub_print;
		string subname;
		subname = $sformatf("SUB%1d",n);
		sub_print = $sformatf("Got a new transaction: %3d", t);
		
		`uvm_info(subname, sub_print, UVM_LOW)
	endfunction
endclass

class day57_test extends uvm_test;
	`uvm_component_utils(day57_test)
	
	sender SEND;
	subscriber SUB1;
	subscriber SUB2;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		SEND = sender::type_id::create("SEND", this);
		uvm_config_db#(int)::set(this, "sub1", "sub_id", 1);
		SUB1 = subscriber#(int)::type_id::create("sub1", this);
		uvm_config_db#(int)::set(this, "sub2", "sub_id", 2);
		SUB2 = subscriber#(int)::type_id::create("sub2", this);
	endfunction
	
	virtual function void connect_phase (uvm_phase phase);
		SEND.sender_ap.connect(SUB1.analysis_export);
		SEND.sender_ap.connect(SUB2.analysis_export);
	endfunction
endclass
	
module day57_tb;
  initial begin
    run_test("day57_test");
  end
endmodule
    