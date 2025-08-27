//apb slave monitor
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(apb_slave_monitor)
  
  	virtual apb_slave_if vif;
	
	uvm_analysis_port#(apb_slave_item) mon_analysis_port;
	
	function new(string name="apb_slave_monitor",uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      	mon_analysis_port = new("mon_analysis_port", this);
      	if(!uvm_config_db#(virtual apb_slave_if)::get(this,"","apb_slave_vif",vif)) begin
			`uvm_fatal("MONITOR","Couldn't get a handle to the virtual interface")
		end
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		apb_slave_item item = new;
      	super.run_phase(phase);
      	
		forever begin
          	
 			item.psel=vif.cb.psel;
            item.penable=vif.cb.penable;
            item.paddr=vif.cb.paddr;
            item.pwrite=vif.cb.pwrite;
           	item.pwdata=vif.cb.pwdata;
    		item.prdata=vif.prdata;
           	item.pready=vif.pready;
			`uvm_info(get_type_name(), item.tx2string(), UVM_LOW);
			mon_analysis_port.write(item);
			@(posedge vif.cb);
		end
	endtask
endclass