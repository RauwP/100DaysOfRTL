`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_master_raw_seq extends uvm_sequence;
    `uvm_object_utils(apb_master_raw_seq)

    rand int num_txn;
    bit[9:0] wr_addr[$];

    function new(string name="apb_master_raw_seq");
        super.new(name);
    endfunction

    constraint apb_num_txn{num_txn inside {[20:100]};}

    virtual task body();
        string tx;
        for(int i=0; i<num_txn; i++) begin
            //The first transaction is a write!
            apb_master_item seq_item = apb_master_item::type_id::create("seq_item");
            `uvm_info("SEQUENCE", "Starting a new APB Master write seq item.", UVM_LOW)

            start_item(seq_item);
            void'(seq_item.randomize() with {seq_item.psel == 1 && seq_item.pwrite == 1;});
            wr_addr.push_back(seq_item.paddr);
            tx = seq_item.tx2string();
            `uvm_info("SEQUENCE", $sformatf("Generated a new APB Master item:\n%s", tx), UVM_LOW)
            finish_item(seq_item);

            `uvm_info("SEQUENCE", "Starting a new APB Master read seq item.", UVM_LOW)
            start_item(seq_item);
            wr_addr.shuffle();
            void'(seq_item.randomize() with {seq_item.psel == 1 && seq_item.pwrite == 0 && seq_item.paddr == wr_addr[0];});
            tx = seq_item.tx2string();
            `uvm_info("SEQUENCE", $sformatf("Generated a new APB Master item:\n%s",tx), UVM_LOW)
            finish_item(seq_item);
        end
    endtask
endclass