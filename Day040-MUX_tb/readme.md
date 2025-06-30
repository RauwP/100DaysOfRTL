# Day 40: Building a Testbench for a MUX

## Task Description

The objective of this challenge is to build a complete, class-based SystemVerilog testbench to verify the functionality of a 2:1 multiplexer (DUT from Day 1). This task integrates many of the concepts learned in previous testbench-focused sessions, such as classes, randomization, and virtual interfaces.

The goal is to create a structured and reusable verification environment that can be easily adapted for other designs.

### Core Functionality:

The testbench should be built using a class-based approach and include the following components:

1.  **Transaction Class:**
    * Create a `class` to represent a single transaction.
    * This class should contain all the stimulus signals for the MUX: `a_i`, `b_i`, and `sel_i`.
    * Use the `rand` keyword to declare these variables as random, allowing for constrained-random stimulus generation.

2.  **Generator Class:**
    * This class is responsible for creating and randomizing transaction objects.
    * It should generate a specified number of transactions to be sent to the driver.

3.  **Driver Class:**
    * This class drives the stimulus from the transaction objects to the DUT.
    * It should contain a `virtual interface` handle to connect to the MUX's physical signals.
    * It will receive transactions from the generator and drive the corresponding values onto the interface signals, synchronized with the clock.

4.  **Scoreboard Class:**
    * This class checks the correctness of the DUT's output.
    * It should independently calculate the expected output based on the input stimulus (`a_i`, `b_i`, `sel_i`) it receives.
    * It compares the DUT's actual output (`y_o`), sampled from the interface, against the calculated expected value and reports any mismatches.

5.  **Environment and Top Module:**
    * An environment class to construct and connect all the testbench components.
    * A top-level module to instantiate the DUT, the testbench interface, and the testbench environment.

### Key Concepts & Syntax Learned

* **Class-Based Verification:** Encapsulating testbench components like drivers, generators, and scoreboards into classes to create a modular, scalable, and reusable verification environment. This is a fundamental concept in modern verification methodologies like UVM.

* **Randomization (`rand`):** Using the `rand` keyword within a class to define variables that can be assigned random values. The `randomize()` method is called on an object of the class to generate new random values for these variables.

    ```systemverilog
    class MuxTransaction;
      rand bit [7:0] a_i;
      rand bit [7:0] b_i;
      rand bit       sel_i;
      // ...
    endclass
    ```

* **Virtual Interfaces:** Using a `virtual interface` handle (`virtual my_if vif;`) within a class to provide a connection to the physical signals of the DUT. This allows for a clean separation between the class-based testbench and the static hardware design, making the verification components more reusable.

* **Testbench Component Interaction:** Understanding how different components of a testbench (generator, driver, scoreboard) communicate with each other, often using mailboxes or by passing transaction objects directly.