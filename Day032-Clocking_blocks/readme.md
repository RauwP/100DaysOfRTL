# Day 32: Clocking Blocks

## Task Description

The goal of this challenge is to understand and use a SystemVerilog **`clocking block`** to drive and sample signals in a testbench. Clocking blocks are essential for creating robust, reusable verification components that are synchronized to the Design Under Test (DUT) and free from race conditions.

This task involves building a class-based testbench that drives an APB slave (the DUT from Day 18) through an interface that contains a clocking block.

### Functional Requirements:

1.  **Interface with Clocking Block:** Define an `interface` that contains all the APB signals. Inside this interface, create a `clocking block` that is sensitive to the positive edge of the clock.
2.  **Signal Direction:** Within the clocking block, specify the `input` and `output` directions for each signal from the perspective of the testbench (the driver).
3.  **Class-Based Testbench:** Create a `class` that contains a `virtual interface` handle.
4.  **Drive and Sample:** All driving of stimulus to the DUT and sampling of signals from the DUT within the class methods must be done through the clocking block (e.g., `vif.cb.signal_name`).
5.  **Synchronization:** Use the clocking block's event (`@(vif.cb)`) to wait for clock cycles, ensuring all actions are perfectly synchronized with the DUT's clock.

### Key Concepts & Syntax Learned

* **`clocking` block**: A construct defined within an `interface` that groups signals and specifies their timing and synchronization behavior relative to a specific clock event. Its primary purpose is to eliminate race conditions between the testbench and the DUT.

* **Defining a Clocking Block**: It is defined with a name, a clock event, and a list of signals with their directions.
    ```systemverilog
    interface my_if(input clk);
      logic req, gnt;
      
      clocking tb_cb @(posedge clk);
        // Directions are from the testbench's point of view
        output req;
        input  gnt;
      endclocking
    endinterface
    ```

* **Driving Signals via Clocking Block**: Signals are driven without blocking assignments. The clocking block automatically handles the timing to drive the signal just before the clock edge.
    ```systemverilog
    // In a task within a class
    // This drives 'req' at the right time relative to the clock edge.
    vif.tb_cb.req <= 1'b1; 
    ```

* **Waiting for a Clock Cycle**: Instead of `@(posedge clk)`, you can wait for the clocking block event itself, which is the standard practice for writing reusable, clock-agnostic verification components.
    ```systemverilog
    // Wait for one cycle of the clocking block's event
    @(vif.tb_cb);
	```
* **Check out this clocking block paper Rahul shared on his Linkedin for more info on how to correctly use clocking blocks: [Link](https://www.verilab.com/post/snug-austin-2012-best-paper-taming-testbench-timing-times-up-for-clocking-block-confusion) **
