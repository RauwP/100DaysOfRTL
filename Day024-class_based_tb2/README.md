# Day 24
## Task: Create a Class-Based Testbench for the APB Slave

The goal for today is to build a reusable, class-based testbench to verify the APB Slave DUT (`day18`) that you designed previously.

You will need to generate APB transactions from within a SystemVerilog `class`. The main challenge is to determine how your dynamic testbench class can drive and monitor the signals on the static `day23` interface connected to the DUT.

### Requirements

1.  **Create a Testbench Class:**
    * Define a class named `day24`.
    * Inside the class, create a `task` that will generate randomized APB read and write transactions.
    * This task should drive the APB signals (`psel`, `penable`, `paddr`, etc.) and wait for the `pready` signal from the slave.

2.  **Create a Top-Level Testbench Module:**
    * Instantiate the `clk`, `reset`, the `day23` interface, and the `day18` DUT.
    * Instantiate the `day24` class.
    * From your top-level module, you need to start the transaction generation task that you defined within your class.

### Testbench Structure
```sketch
+-------------------------------------------------+
|              day24_tb (Top Module)              |
|                                                 |
|  +-----------------+       +------------------+ |
|  | day24           |       | day18            | |
|  | (Class / Master)|       | (Module / DUT)   | |
|  | [The Brain]     |       | [The Design]     | |
|  +-------+---------+       +--------+---------+ |
|          |                          |           |
|  (Virtual Interface)                (Ports)     |
|          |                          |           |
|          +-----------+--------------+           |
|                      |                          |
|                +-----+-------+                  |
|                | day23       |                  |
|                |(Interface)  |                  |
|                | [The Cable] |                  |
|                +-------------+                  |
|                                                 |
+-------------------------------------------------+
````


Use the following structure as a starting point for your solution. You will need to fill in the missing logic.

```systemverilog
// A class to define and generate APB stimulus
class day24;

  // How can this class gain access to the interface signals to drive the DUT?

  // TODO: Implement a task to generate random APB read and write transfers.
  task run_test();
    // Drive vif.psel, vif.penable, etc.
  endtask

endclass

// Top-level module to connect the testbench and the DUT
module day24_tb();

  logic clk;
  logic reset;

  // Instantiate the APB interface
  day23 apb_if (
    .clk(clk),
    .reset(reset)
  );

  // Instantiate the APB Slave DUT from Day 18
  day18 apb_slave_dut (
    .clk(clk),
    .reset(reset),
    .apb_if(apb_if.apb_slave) // Connect the slave modport
  );

  // TODO: Instantiate the 'day24' class and call the run_test task
  initial begin
    // Clock and reset generation
  end

endmodule