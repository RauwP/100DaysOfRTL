`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_master_driver extends uvm_driver#(apb_master_item);
    `uvm_component_utils(apb_master_driver)

    virtual apb_master_if vif;

    function new(string name="apb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_master_if)::get(this,"","apb_master_vif",vif)) `uvm_fatal("DRIVER", "Couldn't get the handle to the virtual interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            apb_master_item item;
           `uvm_info("DRIVER","Waiting to get the item from the sequencer.", UVM_LOW)

           seq_item_port.get_next_item(item);
           //TODO: drive the signals - only need to drive the pready and prdata signals.
           vif.psel <= 1'b0;
           vif.penable <= 1'b0;
           @(vif.cb);
           seq_item_port.item_done(); 
        end
    endtask
endclass