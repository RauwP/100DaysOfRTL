# Day 44: Parameterized Testbench Classes

## Task Description

This challenge introduces a powerful SystemVerilog feature for creating highly reusable verification components: **parameterized classes**. The goal is to take a parameterized DUT (like the Fixed Priority Arbiter from Day 14) and build a testbench where the verification components, especially the transaction class, are also parameterized.

This allows you to verify different configurations of the same DUT (e.g., a 4-port arbiter, an 8-port arbiter, or a 16-port arbiter) without rewriting your testbench classes. You simply change a parameter value at the point of instantiation.

### Core Functionality:

1.  **Select a Parameterized DUT:** Choose a design from a previous day that has parameters, such as the `day14` Fixed Priority Arbiter (`parameter NUM_PORTS = 4`).
2.  **Create a Parameterized Transaction Class:** Define your transaction class (e.g., `ArbiterTransaction`) with a parameter that matches the DUT's parameter (e.g., `NUM_PORTS`). The width of the `req` and `gnt` vectors inside the class will depend on this parameter.
3.  **Build a Parameterized Testbench:** Ensure that your driver, monitor, and scoreboard can handle the parameterized transaction object.
4.  **Instantiate with Specific Values:** In your top-level test, create instances of your parameterized classes with a specific value that matches the DUT instance you are testing (e.g., `ArbiterTransaction #(.NUM_PORTS(8))`).
5.  **Verification:** The testbench should run and correctly verify the DUT for the chosen parameter value.

### Key Concepts & Syntax Learned

* **Parameterized Classes:** A class that can be customized with parameters when it is instantiated. This is the cornerstone of creating generic, reusable components like drivers and scoreboards that can adapt to different data widths, bus sizes, or buffer depths.

* **Defining a Parameterized Class:** You define parameters for a class using the `#(parameter ...)` syntax, similar to how you define them for a module.

    ```systemverilog
    class ArbiterTransaction #(parameter NUM_PORTS = 4);
      // The width of this vector now depends on the parameter
      rand bit [NUM_PORTS-1:0] req;
           bit [NUM_PORTS-1:0] gnt;
      // ...
    endclass
    ```

* **Instantiating a Parameterized Class (Specialization):** When you create an object of a parameterized class, you must specify the parameter values. This is called "specialization."

    ```systemverilog
    // In your test or environment...
    // Create a transaction object specialized for an 8-port arbiter
    ArbiterTransaction #(.NUM_PORTS(8)) my_8_port_txn;
    my_8_port_txn = new();
    ```

* **Benefits of Parameterization:**
    * **Reusability:** Write one set of verification components and use them for many different DUT configurations.
    * **Scalability:** Easily scale your testbench up or down to match new versions of the DUT without major code changes.
    * **Maintainability:** Avoid code duplication. If you need to fix a bug in your scoreboard logic, you only have to fix it in one place, not in separate versions for 4-port, 8-port, and 16-port arbiters.

