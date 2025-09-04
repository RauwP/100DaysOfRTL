`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_master_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_master_scoreboard)

    bit[31:0] mem [bit[9:0]];

    uvm_analysis_imp #(apb_master_item, apb_master_scoreboard) m_analysis_imp;

    function new(string name = "apb_master_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_analysis_imp = new("apb_master_imp", this);
    endfunction

    virtual function write(apb_master_item item); // implement the write function
        logic[31:0] mem_data;
        `uvm_info("SCOREBOARD", "Got a new transaction.", UVM_LOW);
        //Write into memory on a write.
        if(item.psel & item.penable & item.pwrite & item.pready) mem[item.paddr] = item.pwdata;
        //read and compare on a read
        if(item.psel & item.penable & ~item.pwrite & item.pready) begin
            mem_data = mem[item.paddr];
            if(mem_data !== item.prdata) `uvm_fatal("SCOREBOARD", $sformatf("APB Slave read data mismatch. Expected: %b. Got: %b.", mem_data, item.prdata))
        end
    endfunction
endclass