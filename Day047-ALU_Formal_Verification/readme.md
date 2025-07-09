# Day 47: Formal Verification for an ALU

## Task Description

This challenge builds on the previous day's introduction to formal verification by applying the same principles to a more complex, multi-function design: the 8-bit ALU from Day 4.

The goal is to use SystemVerilog Assertions (SVA) to write a comprehensive set of properties that fully define the correct behavior of the ALU. A formal verification tool will then be used to mathematically prove that the RTL implementation adheres to this specification for all possible input values and for every operation code.

### Core Functionality:

You must write formal properties to verify every operation of the ALU. This means creating a specific assertion for each of the 8 operation codes (`op_i`):

1.  **`3'b000` (ADD):** Assert that when `op_i` is `000`, the output `alu_o` is equal to `a_i + b_i`.
2.  **`3'b001` (SUB):** Assert that when `op_i` is `001`, `alu_o` is equal to `a_i - b_i`.
3.  **`3'b010` (SLL):** Assert that when `op_i` is `010`, `alu_o` is equal to `a_i` shifted left by `b_i[2:0]`.
4.  **`3'b011` (LSR):** Assert that when `op_i` is `011`, `alu_o` is equal to `a_i` shifted right by `b_i[2:0]`.
5.  **`3'b100` (AND):** Assert that when `op_i` is `100`, `alu_o` is equal to `a_i & b_i`.
6.  **`3'b101` (OR):** Assert that when `op_i` is `101`, `alu_o` is equal to `a_i | b_i`.
7.  **`3'b110` (XOR):** Assert that when `op_i` is `110`, `alu_o` is equal to `a_i ^ b_i`.
8.  **`3'b111` (EQL):** Assert that when `op_i` is `111`, `alu_o` is `1` if `a_i == b_i` and `0` otherwise.

You should also include `cover` properties to ensure that the formal tool can successfully explore each of the 8 operation codes.

### Key Concepts & Syntax Learned

* **Writing Properties for Data-Path Logic:** This task provides excellent practice for capturing the behavior of arithmetic and logical operations in SVA. The properties directly model the specification of the DUT.

    ```systemverilog
    // Example property for the ADD operation
    property p_check_add;
      // For any combination of inputs...
      @(*)
        // IF the operation code is for ADD...
        (op_i == 3'b000) |->
        // THEN the output must equal the sum.
        (alu_o == a_i + b_i);
    endproperty
    assert_add: assert property(p_check_add);
    ```

* **Exhaustive Proof:** Unlike simulation, which would require millions of cycles to test every combination of `a_i`, `b_i`, and `op_i`, formal verification proves this correctness exhaustively and instantly. If there is any corner-case bug (e.g., an issue with carry propagation on a specific input pair), the formal tool will find it and provide a counter-example.

* **Using `assume` for Constraints (Advanced):** In more complex designs, you might need to constrain the inputs to valid values. For example, if an operation code was illegal, you could tell the formal tool to ignore it using an `assume` property.

    ```systemverilog
    // Example: Assume the operation code is always valid
    assume_valid_op: assume property (@(*) op_i inside {[0:7]});
    ```

