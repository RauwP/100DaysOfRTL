`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_master_basic_seq extends uvm_sequence;
    `uvm_object_utils(apb_master_basic_seq)

    rand int num_tx;

    function new(string name = "apb_master_basic_seq");
        super.new(name);
    endfunction

    constraint apb_num_tx {
        num_tx inside {[20:50]};
    }

    virtual task body();
        string tx;
        for(int i=0; i<num_tx; i++) begin
            apb_master_item item = apb_master_item::type_id::create("seq_item");
            `uvm_info("SEQUENCE", "Starting a new APB Master item.", UVM_LOW)
            start_item(item);
            void'(item.randomize());
            tx = item.tx2string();
            `uvm_info("SEQUENCE", $sformatf("Generated a new APB Master item: %s", tx), UVM_LOW)
            finish_item(item);
        end
        `uvm_info("SEQUENCE","Finished sending APB Master items.", UVM_LOW)
    endtask
endclass