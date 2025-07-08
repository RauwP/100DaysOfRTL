# Day 46: Formal Verification for a Mux

## Task Description

Welcome to the world of Formal Verification! Instead of writing a testbench to simulate specific scenarios, today's task is to **mathematically prove** that the 2:1 Mux from Day 1 is correct for *all possible legal inputs*.

We will use SystemVerilog Assertions (SVA) to write properties that capture the design's intent. A formal verification tool will then analyze these properties against the Mux's RTL to either prove they can never be violated or provide a counter-example (a specific waveform) showing how a bug can occur.

### Core Functionality:

The goal is to write a formal properties file to verify the Mux. This involves:

1.  **Asserting Correct Behavior**: Write an assertion that checks the fundamental logic of the Mux. The property should state: "Whenever the select line `sel_i` is high, the output `y_o` must equal the input `a_i`, and whenever `sel_i` is low, `y_o` must equal `b_i`."
2.  **Covering Key Scenarios**: Write cover properties to ensure that the formal tool can actually explore the core functionality. Specifically, prove that it's possible for the `sel_i` line to be both high and low, ensuring our proof is not trivial.

### Key Concepts & Syntax Learned

* **Formal Verification**: A verification technique that uses mathematical methods to prove or disprove the correctness of a design with respect to a formal specification. Unlike dynamic simulation, which only checks a subset of possible input values, formal verification is exhaustive and can find corner-case bugs that simulation might miss.

* **`assert property`**: The primary construct used to define a property that must hold true under all conditions. If a formal tool can find any scenario where the assertion fails, it will generate an error.

    ```systemverilog
    // General syntax
    property check_mux_logic;
      // For combinational logic, we can check the property continuously
      @(*) (sel_i === 1'b1) |-> (y_o === a_i);
    endproperty

    assert_mux_logic: assert property (check_mux_logic);
    ```

* **`cover property`**: Used to check for reachability. It's a sanity check to ensure that a specific scenario or state in your design is possible. If a `cover` property is unreachable, it might indicate an issue in the design or that your assumptions are too restrictive.

    ```systemverilog
    // Example: Ensure the 'select high' case can be tested
    cover_sel_high: cover property (@(*) sel_i === 1'b1);
    ```

* **Implication Operator (`|->`)**: This is a cornerstone of SVA. The expression `antecedent |-> consequent` means "if the `antecedent` (the condition on the left) is true, then the `consequent` (the expression on the right) must also be true in that same time step." If the antecedent is false, the property passes vacuously.

