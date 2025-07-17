# Day 56: UVM Hello World

## Task Description

Implement a minimal UVM test that prints "Hello, World!" during the run phase, and displays the UVM component hierarchy at the end of the elaboration.

## Implementation Guidelines

1. **Include UVM Macros & Packages**
```systemverilog
	`include "uvm_macros.svh"
	import uvm_pkg::*;
```

2. **Define the Test Class (day56)**
```systemverilog
	class day56 extends uvm_test;
		//Register with factory
		`uvm_component_utils(day56)
	
		//Constructor
		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction
	
		// Hello world in run_phase
		virtual task run_phase(uvm_phase phase);
			`uvm_info("Day56", "Hello, World!", UVM_LOW);
		endtask
  
		// Print topology after elaboration
		virtual function void end_of_elaboration_phase(uvm_phase phase);
			uvm_top.print_topology();
		endfunction
	endclass
```

3. **Top-Level TestBench**
```systemverilog
	module day56_tb;
		initial begin
			run_test("day56");
		end
	endmodule
```

## Key Concepts

*`uvm_test` base class.

*Factory registration via `uvm_component_utils`.

*Reportin Macro `uvm_info`

*Test invocation: `run_test("day56")`