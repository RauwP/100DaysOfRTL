//apb slave driver
`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_slave_driver extends uvm_driver#(apb_slave_item);
	`uvm_component_utils(apb_slave_driver)
	
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
			apb_slave_item d_item;
			`uvm_info("DRIVER","Waiting for the item from the sequencer", UVM_LOW)
			seq_item_port.get_next_item(d_item);
			//drive the item to the RTL ports,
			//only need to drive the pready and prdata signals
			vif.pready <= d_item.pready;
			vif.prdata <= d_item.prdata;
			//wait for the tx to be accepted
			forever begin
				if(vif.psel & vif.penable & vif.pready) break;//break the loop if it is accepted
              @(posedge vif.clk);//otherwise wait for the next cycle
			end
          	@(posedge vif.clk);
			seq_item_port.item_done();
		end
	endtask
endclass