# Day 41: Building a Testbench for an ALU

## Task Description

This challenge builds upon the class-based testbench structure from Day 40. The goal is to verify the 8-bit Arithmetic Logic Unit (ALU) designed in Day 4. This task requires a more sophisticated scoreboard, as it needs to correctly predict the outcome of multiple operations (ADD, SUB, SHL, etc.).

The objective is to create a robust, constrained-random verification environment that thoroughly exercises all functionalities of the ALU.

### Core Functionality:

The testbench should be built using a class-based approach and include the following components:

1.  **Transaction Class:**
    * Create a class to represent a single ALU transaction.
    * It should contain `rand` variables for the inputs `a_i`, `b_i`, and the 3-bit operation `op_i`.

2.  **Generator Class:**
    * This class will create and `randomize()` transaction objects.
    * Consider adding constraints to ensure all 8 operation codes are generated and tested.

3.  **Driver Class:**
    * Drives the randomized `a_i`, `b_i`, and `op_i` values to the ALU's interface, synchronized to a clock.

4.  **Scoreboard Class:**
    * This is the most critical component for this challenge. It must contain a **behavioral model** of the ALU.
    * For each transaction it receives, it must calculate the expected `alu_o` based on the `op_i`. A `case` statement is perfect for modeling this behavior.
    * It then compares the DUT's actual output against its calculated expected value and reports any mismatches.

### Key Concepts & Syntax Learned

* **Behavioral Reference Model**: A crucial concept in verification where you create a simple, easy-to-read model of the DUT's functionality within your testbench (usually in the scoreboard). This model, written in a high-level style (like a `case` statement or function calls), serves as the "golden reference" to check the RTL's correctness. The key is that the reference model and the RTL are implemented differently, so a bug is unlikely to exist in both.

    ```systemverilog
    // Inside the scoreboard's checking task...
    case (item.op_i)
      3'b000: expected_y = item.a_i + item.b_i;
      3'b001: expected_y = item.a_i - item.b_i;
      3'b010: expected_y = item.a_i << item.b_i[2:0];
      // ...and so on for all other operations
    endcase
    ```

* **Constrained Randomization (`constraint`)**: While basic `randomize()` is powerful, constraints give you fine-grained control over stimulus generation. You can use them to ensure all operations are tested or to focus on interesting corner cases.

    ```systemverilog
    class ALU_Transaction;
      rand bit [7:0] a_i, b_i;
      rand bit [2:0] op_i;

      // Example: Constraint to avoid the invalid operation code
      constraint c_valid_op { op_i inside {3'b000, 3'b001, ..., 3'b111}; }
    endclass
    ```