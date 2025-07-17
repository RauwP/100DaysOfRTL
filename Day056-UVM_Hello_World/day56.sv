//day56 - uvm hello world

`include "uvm_macros.svh"
import uvm_pkg::*;

class day56 extends uvm_test;
  
  `uvm_component_utils(day56)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    `uvm_info("Day56", "Hello, World!", UVM_LOW)
  endtask
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
endclass

module day56_tb;
  initial begin
    run_test("day56");
  end
endmodule
    